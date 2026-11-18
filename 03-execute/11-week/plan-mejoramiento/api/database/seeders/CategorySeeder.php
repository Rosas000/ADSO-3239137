<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        foreach ([
            ['name' => 'Sillas', 'slug' => 'sillas'],
            ['name' => 'Mesas', 'slug' => 'mesas'],
            ['name' => 'Carpas', 'slug' => 'carpas'],
            ['name' => 'Tarimas', 'slug' => 'tarimas'],
            ['name' => 'Decoración', 'slug' => 'decoracion'],
        ] as $category) {
            Category::updateOrCreate(['slug' => $category['slug']], ['name' => $category['name']]);
        }
    }
}
