<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Services\RentalService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FrozenSnapshotTest extends TestCase
{
    use RefreshDatabase;

    public function test_la_linea_conserva_datos_aunque_el_catalogo_cambie(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create([
            'category_id' => $category->id,
            'reference' => 'SIL-001',
            'name' => 'Silla',
            'total_units' => 10,
            'available_units' => 10,
        ]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);

        $rental = app(RentalService::class)->create(
            [['article_id' => $article->id, 'quantity' => 2]],
            $organizer->id,
            $advisor->id
        );

        $article->update(['name' => 'Silla NUEVA', 'reference' => 'SIL-999']);

        $line = $rental->lines()->first();
        $this->assertSame('SIL-001', $line->article_reference);
        $this->assertSame('Silla', $line->article_name);
    }
}
