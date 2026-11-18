<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Services\RentalService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ReturnCreateTest extends TestCase
{
    use RefreshDatabase;

    private function makeRental(): array
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 10, 'available_units' => 10]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        $rental = app(RentalService::class)->create([['article_id' => $article->id, 'quantity' => 4]], $organizer->id, $advisor->id);
        return [$rental, $article, $advisor];
    }

    public function test_devolucion_parcial_incrementa_inventario_y_mantiene_activo(): void
    {
        [$rental, $article, $advisor] = $this->makeRental();
        $line = $rental->lines()->first();

        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->postJson("/api/v1/rentals/{$rental->id}/returns", [
                'lines' => [['rental_line_id' => $line->id, 'quantity' => 1]],
            ])->assertStatus(201);

        $this->assertSame(7, $article->fresh()->available_units);
        $this->assertSame('active', $rental->fresh()->status->value);
        $this->assertSame(1, $line->fresh()->returned_quantity);
    }

    public function test_devolucion_total_cambia_estado_a_returned(): void
    {
        [$rental, $article, $advisor] = $this->makeRental();
        $line = $rental->lines()->first();

        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->postJson("/api/v1/rentals/{$rental->id}/returns", [
                'lines' => [['rental_line_id' => $line->id, 'quantity' => 4]],
            ])->assertStatus(201);

        $this->assertSame(10, $article->fresh()->available_units);
        $this->assertSame('returned', $rental->fresh()->status->value);
    }

    public function test_devolucion_que_excede_pendiente_responde_422(): void
    {
        [$rental, $article, $advisor] = $this->makeRental();
        $line = $rental->lines()->first();

        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->postJson("/api/v1/rentals/{$rental->id}/returns", [
                'lines' => [['rental_line_id' => $line->id, 'quantity' => 5]],
            ])->assertStatus(422);
    }
}
