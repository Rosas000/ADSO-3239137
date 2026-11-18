<?php

namespace Tests\Feature;

use App\Models\Advisor;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase;

    public function test_login_devuelve_token_con_credenciales_validas(): void
    {
        Advisor::create([
            'name' => 'Asesor',
            'email' => 'asesor@eventfurniture.co',
            'password' => Hash::make('secreto'),
        ]);

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'asesor@eventfurniture.co',
            'password' => 'secreto',
        ]);

        $response->assertOk()->assertJsonStructure(['token', 'advisor']);
    }

    public function test_login_responde_401_con_credenciales_invalidas(): void
    {
        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'noexiste@eventfurniture.co',
            'password' => 'incorrecta',
        ]);

        $response->assertStatus(401)
            ->assertJsonPath('message', 'Las credenciales no son válidas.');
    }
}
