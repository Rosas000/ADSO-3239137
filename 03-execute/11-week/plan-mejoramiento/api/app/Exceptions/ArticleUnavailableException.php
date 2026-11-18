<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ArticleUnavailableException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'El artículo no está disponible para alquiler.',
            'errors' => (object) [],
        ], 422);
    }
}
