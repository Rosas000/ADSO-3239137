<?php

namespace App\Services;

use App\Enums\RentalStatus;
use App\Exceptions\RentalAlreadyReturnedException;
use App\Exceptions\ReturnExceedsPendingException;
use App\Models\Article;
use App\Models\Rental;
use App\Models\RentalLine;
use App\Models\RentalReturn;
use App\Models\RentalReturnLine;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class ReturnService
{
    public function processReturn(int $rentalId, array $lines, int $advisorId): RentalReturn
    {
        return DB::transaction(function () use ($rentalId, $lines, $advisorId) {
            $rental = Rental::where('id', $rentalId)->lockForUpdate()->first();

            if ($rental->status !== RentalStatus::Active) {
                throw new RentalAlreadyReturnedException();
            }

            $sorted = collect($lines)->sortBy('rental_line_id')->values();

            $rentalLines = RentalLine::where('rental_id', $rental->id)
                ->whereIn('id', $sorted->pluck('rental_line_id'))
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            $articles = Article::withTrashed()
                ->whereIn('id', $rentalLines->pluck('article_id'))
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            $return = RentalReturn::create([
                'rental_id' => $rental->id,
                'advisor_id' => $advisorId,
                'returned_at' => Carbon::now(),
            ]);

            foreach ($sorted as $item) {
                $line = $rentalLines->get($item['rental_line_id']);
                $pending = $line->quantity - $line->returned_quantity;

                if ($item['quantity'] > $pending) {
                    throw new ReturnExceedsPendingException();
                }

                $line->increment('returned_quantity', $item['quantity']);
                $articles->get($line->article_id)->increment('available_units', $item['quantity']);

                RentalReturnLine::create([
                    'rental_return_id' => $return->id,
                    'rental_line_id' => $line->id,
                    'quantity' => $item['quantity'],
                ]);
            }

            $allComplete = $rental->lines()
                ->whereColumn('returned_quantity', '<', 'quantity')
                ->doesntExist();

            if ($allComplete) {
                $rental->update([
                    'status' => RentalStatus::Returned,
                    'returned_at' => Carbon::now(),
                ]);
            }

            return $return->load('lines');
        });
    }
}
