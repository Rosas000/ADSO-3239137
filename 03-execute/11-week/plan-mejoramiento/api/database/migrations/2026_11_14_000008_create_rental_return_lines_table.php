<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rental_return_lines', function (Blueprint $table) {
            $table->id();
            $table->foreignId('rental_return_id')->constrained('rental_returns')->restrictOnDelete();
            $table->foreignId('rental_line_id')->constrained('rental_lines')->restrictOnDelete();
            $table->integer('quantity');
            $table->timestampsTz();
            $table->index('rental_return_id');
            $table->index('rental_line_id');
        });

        DB::statement('ALTER TABLE rental_return_lines ADD CONSTRAINT rental_return_lines_quantity_positive CHECK (quantity > 0)');
    }

    public function down(): void
    {
        Schema::dropIfExists('rental_return_lines');
    }
};
