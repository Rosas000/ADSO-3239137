<?php

namespace App\Http\Controllers;

use App\Models\Organizer;
use App\Services\RentalService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OrganizerController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Organizer::query();

        if ($request->filled('q')) {
            $q = $request->input('q');
            $query->where(function ($inner) use ($q) {
                $inner->where('document_number', 'like', "%{$q}%")
                      ->orWhere('full_name', 'like', "%{$q}%");
            });
        }

        return response()->json($query->paginate($request->integer('per_page', 15)));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'document_number' => ['required', 'string', 'max:20'],
            'full_name' => ['required', 'string', 'max:150'],
            'phone' => ['required', 'string', 'max:20'],
            'email' => ['nullable', 'email', 'max:150'],
        ]);

        if (Organizer::where('document_number', $data['document_number'])->exists()) {
            return response()->json([
                'message' => 'Ya existe un organizador con ese documento.',
                'errors' => (object) [],
            ], 409);
        }

        return response()->json(['data' => Organizer::create($data)], 201);
    }

    public function show(int $id): JsonResponse
    {
        $organizer = Organizer::findOrFail($id);
        $service = app(RentalService::class);

        return response()->json(['data' => [
            'id' => $organizer->id,
            'document_number' => $organizer->document_number,
            'full_name' => $organizer->full_name,
            'phone' => $organizer->phone,
            'email' => $organizer->email,
            'pending_units' => $service->pendingUnitsFor($organizer),
            'is_overdue' => $service->hasOverdueRentals($organizer),
            'active_rentals' => $organizer->rentals()
                ->where('status', 'active')
                ->with('lines')
                ->get(),
        ]]);
    }
}
