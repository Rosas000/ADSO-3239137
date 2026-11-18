<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\RentalController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/rentals', [RentalController::class, 'store']);
    Route::get('/rentals/{id}', [RentalController::class, 'show']);
});
