<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Services\RentalService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MostRequestedReportTest extends TestCase
{
    use RefreshDatabase;

    public function test_el_reporte_ordena_por_cantidad_descendente(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $art1 = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 20, 'available_units' => 20]);
        $art2 = Article::create(['category_id' => $category->id, 'reference' => 'SIL-002', 'name' => 'Otra', 'total_units' => 20, 'available_units' => 20]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        $service = app(RentalService::class);

        $service->create([['article_id' => $art1->id, 'quantity' => 5]], $organizer->id, $advisor->id);
        $service->create([['article_id' => $art1->id, 'quantity' => 3], ['article_id' => $art2->id, 'quantity' => 2]], $organizer->id, $advisor->id);

        $response = $this->withToken($advisor->createToken('t')->plainTextToken)
            ->getJson('/api/v1/reports/most-requested');

        $response->assertOk();
        $this->assertEquals($art1->id, $response->json('data.0.article_id'));
        $this->assertEquals(8, $response->json('data.0.total_quantity'));
        $this->assertEquals(2, $response->json('data.1.total_quantity'));
    }
}
