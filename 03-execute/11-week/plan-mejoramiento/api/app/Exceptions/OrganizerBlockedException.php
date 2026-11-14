<?php

namespace App\Exceptions;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OrganizerBlockedException extends \RuntimeException
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'El organizador tiene alquileres vencidos. Debe devolverlos antes de recibir más artículos.',
            'errors' => (object) [],
        ], 422);
    }
}
