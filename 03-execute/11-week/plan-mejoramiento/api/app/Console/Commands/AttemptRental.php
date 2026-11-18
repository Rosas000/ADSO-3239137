<?php

namespace App\Console\Commands;

use App\Exceptions\InsufficientUnitsException;
use App\Services\RentalService;
use Illuminate\Console\Command;

class AttemptRental extends Command
{
    protected $signature = 'rental:attempt {organizer} {article} {quantity}';
    protected $description = 'Intenta un alquiler y reporta el resultado para pruebas de concurrencia';

    public function handle(): int
    {
        try {
            app(RentalService::class)->create(
                [['article_id' => (int) $this->argument('article'), 'quantity' => (int) $this->argument('quantity')]],
                (int) $this->argument('organizer'),
                1
            );
            $this->info('OK');
        } catch (InsufficientUnitsException $e) {
            $this->info('FAIL:409');
        } catch (\Throwable $e) {
            $this->info('FAIL:' . get_class($e));
        }

        return 0;
    }
}
