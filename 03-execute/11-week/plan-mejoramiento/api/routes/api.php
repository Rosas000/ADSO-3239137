<?php

use App\Http\Controllers\ArticleController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\OrganizerController;
use App\Http\Controllers\RentalController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\ReturnController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/categories', [CategoryController::class, 'index']);

    Route::get('/articles', [ArticleController::class, 'index']);
    Route::post('/articles', [ArticleController::class, 'store']);
    Route::put('/articles/{id}', [ArticleController::class, 'update']);
    Route::delete('/articles/{id}', [ArticleController::class, 'destroy']);

    Route::get('/organizers', [OrganizerController::class, 'index']);
    Route::post('/organizers', [OrganizerController::class, 'store']);
    Route::get('/organizers/{id}', [OrganizerController::class, 'show']);

    Route::post('/rentals', [RentalController::class, 'store']);
    Route::get('/rentals/{id}', [RentalController::class, 'show']);
    Route::post('/rentals/{id}/returns', [ReturnController::class, 'store']);

    Route::get('/reports/most-requested', [ReportController::class, 'mostRequested']);
});
