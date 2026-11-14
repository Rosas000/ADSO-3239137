<?php

namespace App\Services;

use App\Enums\RentalStatus;
use App\Exceptions\OrganizerBlockedException;
use App\Exceptions\RentalLimitExceededException;
use App\Models\Organizer;
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
}
