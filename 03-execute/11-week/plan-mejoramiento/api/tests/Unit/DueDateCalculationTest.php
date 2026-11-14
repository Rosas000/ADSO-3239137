<?php

namespace Tests\Unit;

use App\Services\RentalService;
use Carbon\Carbon;
use Tests\TestCase;

class DueDateCalculationTest extends TestCase
{
    public function test_due_at_es_rented_at_mas_tres_dias_en_utc(): void
    {
        $rented = Carbon::parse('2026-11-14T10:00:00Z');

        $due = app(RentalService::class)->calculateDueAt($rented);

        $this->assertSame('2026-11-17T10:00:00', $due->format('Y-m-d\TH:i:s'));
        $this->assertSame('UTC', $due->timezoneName);
    }
}
