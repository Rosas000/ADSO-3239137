<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class RentalLine extends Model
{
    use HasFactory;

    protected $fillable = [
        'rental_id',
        'article_id',
        'article_reference',
        'article_name',
        'quantity',
        'returned_quantity',
    ];

    protected function casts(): array
    {
        return [
            'quantity' => 'integer',
            'returned_quantity' => 'integer',
        ];
    }

    public function rental(): BelongsTo
    {
        return $this->belongsTo(Rental::class);
    }

    public function article(): BelongsTo
    {
        return $this->belongsTo(Article::class);
    }

    public function returnLines(): HasMany
    {
        return $this->hasMany(RentalReturnLine::class);
    }

    public function pendingUnits(): int
    {
        return $this->quantity - $this->returned_quantity;
    }
}
