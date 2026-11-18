<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReturnExceedsPendingException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'La cantidad a devolver supera las unidades pendientes de la línea.',
            'errors' => (object) [],
        ], 422);
    }
}
