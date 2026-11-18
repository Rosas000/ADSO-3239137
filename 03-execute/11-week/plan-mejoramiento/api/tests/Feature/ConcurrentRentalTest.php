<?php

namespace Tests\Feature;

use App\Models\Advisor;
use App\Models\Article;
use App\Models\Category;
use App\Models\Organizer;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Tests\TestCase;

class ConcurrentRentalTest extends TestCase
{
    use DatabaseMigrations;

    public function test_dos_alquileres_simultaneos_sobre_una_unidad_solo_uno_pasa(): void
    {
        $category = Category::create(['name' => 'Sillas', 'slug' => 'sillas']);
        $article = Article::create(['category_id' => $category->id, 'reference' => 'SIL-001', 'name' => 'Silla', 'total_units' => 1, 'available_units' => 1]);
        $organizer = Organizer::create(['document_number' => '1', 'full_name' => 'Ana', 'phone' => '300']);
        Advisor::create(['name' => 'A', 'email' => 'a@b.co', 'password' => 'x']);

        $env = array_merge(getenv(), [
            'APP_ENV' => 'testing',
            'DB_CONNECTION' => 'pgsql',
            'DB_HOST' => 'db',
            'DB_PORT' => '5432',
            'DB_DATABASE' => 'event_furniture_testing',
            'DB_USERNAME' => 'event_furniture',
            'DB_PASSWORD' => 'cambiar_esta_clave',
        ]);

        $cmd = 'php artisan rental:attempt ' . $organizer->id . ' ' . $article->id . ' 1';
        $pipes = [];
        $descriptors = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];

        $pa = proc_open($cmd, $descriptors, $pipesA, base_path(), $env);
        $pb = proc_open($cmd, $descriptors, $pipesB, base_path(), $env);

        fclose($pipesA[0]);
        fclose($pipesB[0]);
        $outA = stream_get_contents($pipesA[1]);
        $outB = stream_get_contents($pipesB[1]);
        fclose($pipesA[1]);
        fclose($pipesB[1]);
        fclose($pipesA[2]);
        fclose($pipesB[2]);
        proc_close($pa);
        proc_close($pb);

        $outputs = [$outA, $outB];
        $oks = count(array_filter($outputs, fn ($o) => str_contains($o, 'OK')));
        $fails = count(array_filter($outputs, fn ($o) => str_contains($o, 'FAIL:409')));

        $this->assertSame(1, $oks, 'Exactamente un alquiler debe pasar. Salidas: ' . implode(' | ', $outputs));
        $this->assertSame(1, $fails, 'Exactamente uno debe fallar con 409. Salidas: ' . implode(' | ', $outputs));
        $this->assertSame(0, $article->fresh()->available_units);
    }
}
