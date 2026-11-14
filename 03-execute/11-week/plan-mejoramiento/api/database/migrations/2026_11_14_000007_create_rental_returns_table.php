<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rental_returns', function (Blueprint $table) {
            $table->id();
            $table->foreignId('rental_id')->constrained('rentals')->restrictOnDelete();
            $table->foreignId('advisor_id')->constrained('advisors')->restrictOnDelete();
            $table->timestampTz('returned_at');
            $table->timestampsTz();
            $table->index('rental_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rental_returns');
    }
};
