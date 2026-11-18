<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SoftDeleteTest extends TestCase
{
    use RefreshDatabase;

    private function token(): string
    {
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        return $advisor->createToken('t')->plainTextToken;
    }

    public function test_baja_con_unidades_pendientes_responde_422(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 5, 'available_units' => 3]);
        $this->withToken($this->token())->deleteJson("/api/v1/articles/{$article->id}")->assertStatus(422);
    }

    public function test_baja_sin_pendientes_es_logica_y_no_borra_la_fila(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 5, 'available_units' => 5]);
        $this->withToken($this->token())->deleteJson("/api/v1/articles/{$article->id}")->assertOk();
        $this->assertSoftDeleted('articles', ['id' => $article->id]);
    }
}
