<?php

namespace Tests\Feature;

use App\Exceptions\RentalLimitExceededException;
use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Models\Rental;
use App\Models\RentalLine;
use App\Services\RentalService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RentalLimitTest extends TestCase
{
    use RefreshDatabase;

    private function organizerWithPendingUnits(int $pending): Organizer
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create([
            'category_id' => $category->id,
            'reference' => 'SIL-001',
            'name' => 'Silla Tiffany',
            'total_units' => 10,
            'available_units' => 10 - $pending,
        ]);
        $organizer = Organizer::create([
            'document_number' => '123',
            'full_name' => 'Ana',
            'phone' => '300',
        ]);
        $advisor = Advisor::create([
            'name' => 'Asesor',
            'email' => 'asesor@eventfurniture.co',
            'password' => 'secreto',
        ]);
        $rental = Rental::create([
            'organizer_id' => $organizer->id,
            'advisor_id' => $advisor->id,
            'rented_at' => Carbon::now(),
            'due_at' => Carbon::now()->addDays(3),
            'status' => 'active',
        ]);
        RentalLine::create([
            'rental_id' => $rental->id,
            'article_id' => $article->id,
            'article_reference' => 'SIL-001',
            'article_name' => 'Silla Tiffany',
            'quantity' => $pending,
            'returned_quantity' => 0,
        ]);

        return $organizer;
    }

    public function test_superar_el_limite_de_cinco_lanza_excepcion(): void
    {
        $organizer = $this->organizerWithPendingUnits(4);

        $this->expectException(RentalLimitExceededException::class);
        app(RentalService::class)->assertOrganizerWithinLimit($organizer, [
            ['article_id' => 1, 'quantity' => 2],
        ]);
    }

    public function test_dentro_del_limite_no_lanza_excepcion(): void
    {
        $organizer = $this->organizerWithPendingUnits(4);

        app(RentalService::class)->assertOrganizerWithinLimit($organizer, [
            ['article_id' => 1, 'quantity' => 1],
        ]);
        $this->assertTrue(true);
    }
}
