<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('articles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->constrained('categories')->restrictOnDelete();
            $table->string('reference', 50)->unique();
            $table->string('name', 150);
            $table->text('description')->nullable();
            $table->integer('total_units');
            $table->integer('available_units');
            $table->timestampsTz();
            $table->softDeletesTz();
            $table->index('category_id');
            $table->index('deleted_at');
        });

        DB::statement('ALTER TABLE articles ADD CONSTRAINT articles_total_units_positive CHECK (total_units > 0)');
        DB::statement('ALTER TABLE articles ADD CONSTRAINT articles_available_units_range CHECK (available_units >= 0 AND available_units <= total_units)');
    }

    public function down(): void
    {
        Schema::dropIfExists('articles');
    }
};
