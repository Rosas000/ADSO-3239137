<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RentalLimitExceededException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'El organizador no puede tener más de 5 artículos sin devolver.',
            'errors' => (object) [],
        ], 422);
    }
}
