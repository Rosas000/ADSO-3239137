<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Organizer;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OrganizerSearchTest extends TestCase
{
    use RefreshDatabase;

    public function test_busqueda_filtra_por_nombre(): void
    {
        Organizer::create(['document_number' => '1', 'full_name' => 'Ana Ruiz', 'phone' => '300']);
        Organizer::create(['document_number' => '2', 'full_name' => 'Luis Mora', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);

        $response = $this->withToken($advisor->createToken('t')->plainTextToken)
            ->getJson('/api/v1/organizers?q=Ana');

        $names = collect($response->json('data'))->pluck('full_name');
        $this->assertTrue($names->contains('Ana Ruiz'));
        $this->assertFalse($names->contains('Luis Mora'));
    }
}
