<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rentals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('organizer_id')->constrained('organizers')->restrictOnDelete()->index();
            $table->foreignId('advisor_id')->constrained('advisors')->restrictOnDelete();
            $table->timestampTz('rented_at');
            $table->timestampTz('due_at');
            $table->timestampTz('returned_at')->nullable();
            $table->string('status', 20);
            $table->timestampsTz();
            $table->index(['status', 'due_at']);
        });

        DB::statement("ALTER TABLE rentals ADD CONSTRAINT rentals_status_allowed CHECK (status IN ('active', 'returned'))");
        DB::statement("ALTER TABLE rentals ADD CONSTRAINT rentals_returned_consistent CHECK ((status = 'returned') = (returned_at IS NOT NULL))");
    }

    public function down(): void
    {
        Schema::dropIfExists('rentals');
    }
};
