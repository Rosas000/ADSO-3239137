<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use App\Models\Rental;
use App\Models\RentalLine;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OrganizerStatusTest extends TestCase
{
    use RefreshDatabase;

    public function test_show_reporta_vencido_y_unidades_pendientes(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 10, 'available_units' => 8]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);
        $rental = Rental::create([
            'organizer_id' => $organizer->id, 'advisor_id' => $advisor->id,
            'rented_at' => Carbon::now()->subDays(4), 'due_at' => Carbon::now()->subDay(), 'status' => 'active',
        ]);
        RentalLine::create(['rental_id' => $rental->id, 'article_id' => $article->id, 'article_reference' => 'SIL-001', 'article_name' => 'Silla', 'quantity' => 2, 'returned_quantity' => 0]);

        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->getJson("/api/v1/organizers/{$organizer->id}")
            ->assertOk()
            ->assertJsonPath('data.is_overdue', true)
            ->assertJsonPath('data.pending_units', 2);
    }
}
