<?php

namespace Tests\Feature;

use App\Services\RentalService;
use Carbon\Carbon;
use Tests\TestCase;

class RentalDueDateTest extends TestCase
{
    public function test_el_plazo_es_de_tres_dias_calendario(): void
    {
        $now = Carbon::now();

        $due = app(RentalService::class)->calculateDueAt($now);

        $this->assertTrue($now->copy()->addDays(3)->equalTo($due));
    }
}
