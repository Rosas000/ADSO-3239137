<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rental_lines', function (Blueprint $table) {
            $table->id();
            $table->foreignId('rental_id')->constrained('rentals')->restrictOnDelete()->index();
            $table->foreignId('article_id')->constrained('articles')->restrictOnDelete()->index();
            $table->string('article_reference', 50);
            $table->string('article_name', 150);
            $table->integer('quantity');
            $table->integer('returned_quantity')->default(0);
            $table->timestampsTz();
        });

        DB::statement('ALTER TABLE rental_lines ADD CONSTRAINT rental_lines_quantity_positive CHECK (quantity > 0)');
        DB::statement('ALTER TABLE rental_lines ADD CONSTRAINT rental_lines_returned_within_quantity CHECK (returned_quantity >= 0 AND returned_quantity <= quantity)');
    }

    public function down(): void
    {
        Schema::dropIfExists('rental_lines');
    }
};
