<?php

namespace App\Services;

use App\Enums\RentalStatus;
use App\Exceptions\ArticleUnavailableException;
use App\Exceptions\InsufficientUnitsException;
use App\Exceptions\OrganizerBlockedException;
use App\Exceptions\RentalLimitExceededException;
use App\Models\Article;
use App\Models\Organizer;
use App\Models\Rental;
use App\Models\RentalLine;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class RentalService
{
    public const UNIT_LIMIT = 5;
    public const RENTAL_DAYS = 3;

    public function pendingUnitsFor(Organizer $organizer): int
    {
        return (int) RentalLine::whereHas('rental', function ($query) use ($organizer) {
            $query->where('organizer_id', $organizer->id)
                ->where('status', RentalStatus::Active);
        })
            ->select(DB::raw('COALESCE(SUM(quantity - returned_quantity), 0) AS agg'))
            ->value('agg');
    }

    public function hasOverdueRentals(Organizer $organizer): bool
    {
        return $organizer->rentals()
            ->where('status', RentalStatus::Active)
            ->where('due_at', '<', Carbon::now())
            ->whereHas('lines', function ($query) {
                $query->whereColumn('returned_quantity', '<', 'quantity');
            })
            ->exists();
    }

    public function assertOrganizerNotBlocked(Organizer $organizer): void
    {
        if ($this->hasOverdueRentals($organizer)) {
            throw new OrganizerBlockedException();
        }
    }

    public function assertOrganizerWithinLimit(Organizer $organizer, array $lines): void
    {
        $requested = collect($lines)->sum('quantity');

        if ($this->pendingUnitsFor($organizer) + $requested > self::UNIT_LIMIT) {
            throw new RentalLimitExceededException();
        }
    }

    public function calculateDueAt(Carbon $rentedAt): Carbon
    {
        return $rentedAt->copy()->addDays(self::RENTAL_DAYS);
    }

    public function create(array $lines, int $organizerId, int $advisorId): Rental
    {
        return DB::transaction(function () use ($lines, $organizerId, $advisorId) {
            // Bloquear el organizador serializa SUS peticiones concurrentes (ADR-002).
            $organizer = Organizer::where('id', $organizerId)->lockForUpdate()->first();

            $this->assertOrganizerNotBlocked($organizer);
            $this->assertOrganizerWithinLimit($organizer, $lines);

            // Orden ascendente por id: orden deterministico de adquisicion de
            // bloqueos para evitar deadlocks (ADR-002). withTrashed para
            // distinguir baja logica (422) de inexistente (validado antes).
            $sorted = collect($lines)->sortBy('article_id')->values();

            $articles = Article::withTrashed()
                ->whereIn('id', $sorted->pluck('article_id'))
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            $now = Carbon::now();

            $rental = Rental::create([
                'organizer_id' => $organizerId,
                'advisor_id' => $advisorId,
                'rented_at' => $now,
                'due_at' => $this->calculateDueAt($now),
                'status' => RentalStatus::Active,
            ]);

            foreach ($sorted as $line) {
                $article = $articles->get($line['article_id']);

                if ($article === null || $article->trashed()) {
                    throw new ArticleUnavailableException();
                }

                if ($article->available_units < $line['quantity']) {
                    throw new InsufficientUnitsException();
                }

                $article->decrement('available_units', $line['quantity']);

                // RN05: congelar referencia y nombre del catalogo en la linea.
                RentalLine::create([
                    'rental_id' => $rental->id,
                    'article_id' => $article->id,
                    'article_reference' => $article->reference,
                    'article_name' => $article->name,
                    'quantity' => $line['quantity'],
                    'returned_quantity' => 0,
                ]);
            }

            return $rental->load('lines');
        });
    }
}
