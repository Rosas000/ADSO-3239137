<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RentalAlreadyReturnedException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'El alquiler ya fue devuelto en su totalidad.',
            'errors' => (object) [],
        ], 422);
    }
}
