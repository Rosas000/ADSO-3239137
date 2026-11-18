<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ArticleCreateTest extends TestCase
{
    use RefreshDatabase;

    private function token(): string
    {
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        return $advisor->createToken('t')->plainTextToken;
    }

    public function test_crea_articulo_con_inventario_inicial_igual_al_total(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $response = $this->withToken($this->token())->postJson('/api/v1/articles', [
            'category_id' => $category->id,
            'reference' => 'SIL-001',
            'name' => 'Silla',
            'total_units' => 10,
        ]);
        $response->assertStatus(201)->assertJsonPath('data.available_units', 10);
    }

    public function test_referencia_duplicada_responde_409(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $token = $this->token();
        $payload = ['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 5];
        $this->withToken($token)->postJson('/api/v1/articles', $payload);
        $this->withToken($token)->postJson('/api/v1/articles', $payload)->assertStatus(409);
    }
}
