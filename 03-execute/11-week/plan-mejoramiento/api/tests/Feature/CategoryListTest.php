<?php

namespace Tests\Feature;

use App\Models\Advisor;
use Database\Seeders\CategorySeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CategoryListTest extends TestCase
{
    use RefreshDatabase;

    public function test_devuelve_las_cinco_categorias_fijas(): void
    {
        $this->seed(CategorySeeder::class);
        $advisor = Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);

        $this->withToken($advisor->createToken('t')->plainTextToken)
            ->getJson('/api/v1/categories')
            ->assertOk()
            ->assertJsonCount(5, 'data');
    }
}
