<?php

namespace Database\Seeders;

use App\Models\Advisor;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdvisorSeeder extends Seeder
{
    public function run(): void
    {
        Advisor::updateOrCreate(
            ['email' => 'asesor@eventfurniture.co'],
            ['name' => 'Asesor Event Furniture', 'password' => Hash::make('secreto')]
        );
    }
}
