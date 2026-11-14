<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class RentalReturnLine extends Model
{
    use HasFactory;

    protected $fillable = [
        'rental_return_id',
        'rental_line_id',
        'quantity',
    ];

    protected function casts(): array
    {
        return [
            'quantity' => 'integer',
        ];
    }

    public function rentalReturn(): BelongsTo
    {
        return $this->belongsTo(RentalReturn::class);
    }

    public function rentalLine(): BelongsTo
    {
        return $this->belongsTo(RentalLine::class);
    }
}
