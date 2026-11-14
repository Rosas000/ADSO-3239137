<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Organizer extends Model
{
    use HasFactory;

    protected $fillable = [
        'document_number',
        'full_name',
        'phone',
        'email',
    ];

    public function rentals(): HasMany
    {
        return $this->hasMany(Rental::class);
    }
}
