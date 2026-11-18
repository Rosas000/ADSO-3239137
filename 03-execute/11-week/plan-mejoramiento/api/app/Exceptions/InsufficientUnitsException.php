<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class InsufficientUnitsException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'No hay unidades suficientes del artículo solicitado.',
            'errors' => (object) [],
        ], 409);
    }
}
