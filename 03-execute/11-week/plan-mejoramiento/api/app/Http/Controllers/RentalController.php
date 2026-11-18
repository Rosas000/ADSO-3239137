<?php

namespace App\Http\Controllers;

use App\Models\Rental;
use App\Services\RentalService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RentalController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'organizer_id' => ['required', 'integer', 'exists:organizers,id'],
            'lines' => ['required', 'array', 'min:1'],
            'lines.*.article_id' => ['required', 'integer', 'exists:articles,id'],
            'lines.*.quantity' => ['required', 'integer', 'min:1'],
        ]);

        $ids = collect($data['lines'])->pluck('article_id');
        if ($ids->unique()->count() !== $ids->count()) {
            return response()->json([
                'message' => 'No se puede alquilar el mismo artículo dos veces en la misma operación.',
                'errors' => (object) [],
            ], 422);
        }

        $rental = app(RentalService::class)->create(
            $data['lines'],
            (int) $data['organizer_id'],
            (int) $request->user()->id
        );

        return response()->json(['data' => $rental], 201);
    }

    public function show(int $id): JsonResponse
    {
        $rental = Rental::with('lines')->findOrFail($id);

        return response()->json(['data' => $rental]);
    }
}
