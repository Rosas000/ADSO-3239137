<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ArticleCatalogTest extends TestCase
{
    use RefreshDatabase;

    public function test_el_catalogo_excluye_articulos_dados_de_baja(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $visible = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 5, 'available_units' => 5]);
        $borrado = Article::create(['category_id' => $category->id, 'reference' => 'SIL-002', 'name' => 'Otra', 'total_units' => 5, 'available_units' => 5]);
        $borrado->delete();

        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        $response = $this->withToken($advisor->createToken('t')->plainTextToken)
            ->getJson('/api/v1/articles');

        $response->assertOk();
        $refs = collect($response->json('data'))->pluck('reference');
        $this->assertTrue($refs->contains('SIL-001'));
        $this->assertFalse($refs->contains('SIL-002'));
    }
}
