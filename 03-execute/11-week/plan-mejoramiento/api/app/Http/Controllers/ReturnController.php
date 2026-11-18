<?php

namespace App\Http\Controllers;

use App\Services\ReturnService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReturnController extends Controller
{
    public function store(Request $request, int $id): JsonResponse
    {
        $data = $request->validate([
            'lines' => ['required', 'array', 'min:1'],
            'lines.*.rental_line_id' => ['required', 'integer'],
            'lines.*.quantity' => ['required', 'integer', 'min:1'],
        ]);

        $return = app(ReturnService::class)->processReturn(
            $id,
            $data['lines'],
            (int) $request->user()->id
        );

        return response()->json(['data' => $return], 201);
    }
}
