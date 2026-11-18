<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ArticleUpdateTest extends TestCase
{
    use RefreshDatabase;

    public function test_total_por_debajo_de_lo_alquilado_responde_422(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 10, 'available_units' => 6]);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->putJson("/api/v1/articles/{$article->id}", ['total_units' => 3])
            ->assertStatus(422);
    }
}
