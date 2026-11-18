<?php

namespace Tests\Feature;

use App\Models\Advisor;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OrganizerCreateTest extends TestCase
{
    use RefreshDatabase;

    private function token(): string
    {
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        return $advisor->createToken('t')->plainTextToken;
    }

    public function test_crea_organizador(): void
    {
        $this->withToken($this->token())->postJson('/api/v1/organizers', [
            'document_number' => '1001', 'full_name' => 'Ana', 'phone' => '300',
        ])->assertStatus(201);
    }

    public function test_documento_duplicado_responde_409(): void
    {
        $token = $this->token();
        $payload = ['document_number' => '1001', 'full_name' => 'Ana', 'phone' => '300'];
        $this->withToken($token)->postJson('/api/v1/organizers', $payload);
        $this->withToken($token)->postJson('/api/v1/organizers', $payload)->assertStatus(409);
    }
}
