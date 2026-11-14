<?php

namespace Tests\Feature;

use App\Exceptions\OrganizerBlockedException;
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

class OrganizerBlockTest extends TestCase
{
    use RefreshDatabase;

    private function organizerWithRentalDueAt(Carbon $dueAt): Organizer
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create([
            'category_id' => $category->id,
            'reference' => 'SIL-001',
            'name' => 'Silla Tiffany',
            'total_units' => 10,
            'available_units' => 8,
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
            'rented_at' => $dueAt->copy()->subDays(3),
            'due_at' => $dueAt,
            'status' => 'active',
        ]);
        RentalLine::create([
            'rental_id' => $rental->id,
            'article_id' => $article->id,
            'article_reference' => 'SIL-001',
            'article_name' => 'Silla Tiffany',
            'quantity' => 2,
            'returned_quantity' => 0,
        ]);

        return $organizer;
    }

    public function test_organizador_con_alquiler_vencido_queda_bloqueado(): void
    {
        $organizer = $this->organizerWithRentalDueAt(Carbon::now()->subDay());

        $this->expectException(OrganizerBlockedException::class);
        app(RentalService::class)->assertOrganizerNotBlocked($organizer);
    }

    public function test_organizador_con_alquiler_vigente_no_queda_bloqueado(): void
    {
        $organizer = $this->organizerWithRentalDueAt(Carbon::now()->addDay());

        app(RentalService::class)->assertOrganizerNotBlocked($organizer);
        $this->assertTrue(true);
    }
}
