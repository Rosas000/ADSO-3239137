<?php

namespace Tests\Feature;

use App\Exceptions\InsufficientUnitsException;
use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Services\RentalService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class InventoryBoundsTest extends TestCase
{
    use RefreshDatabase;

    public function test_cantidad_mayor_al_inventario_lanza_409_y_no_descuenta(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create([
            'category_id' => $category->id,
            'reference' => 'SIL-001',
            'name' => 'Silla',
            'total_units' => 5,
            'available_units' => 1,
        ]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);

        try {
            app(RentalService::class)->create(
                [['article_id' => $article->id, 'quantity' => 2]],
                $organizer->id,
                $advisor->id
            );
            $this->fail('Debia lanzar InsufficientUnitsException');
        } catch (InsufficientUnitsException $e) {
            $this->assertSame(1, $article->fresh()->available_units);
        }
    }
}
