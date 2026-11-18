<?php

namespace App\Http\Controllers;

use App\Models\Article;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ArticleController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Article::query();

        if ($request->filled('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->input('category'));
            });
        }

        if ($request->filled('search')) {
            $s = $request->input('search');
            $query->where(function ($q) use ($s) {
                $q->where('reference', 'like', "%{$s}%")
                  ->orWhere('name', 'like', "%{$s}%");
            });
        }

        return response()->json($query->paginate($request->integer('per_page', 15)));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'category_id' => ['required', 'integer', 'exists:categories,id'],
            'reference' => ['required', 'string', 'max:50'],
            'name' => ['required', 'string', 'max:150'],
            'description' => ['nullable', 'string'],
            'total_units' => ['required', 'integer', 'min:1'],
        ]);

        if (Article::withTrashed()->where('reference', $data['reference'])->exists()) {
            return response()->json([
                'message' => 'Ya existe un artículo con esa referencia.',
                'errors' => (object) [],
            ], 409);
        }

        $article = Article::create($data + ['available_units' => $data['total_units']]);

        return response()->json(['data' => $article], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $article = Article::findOrFail($id);

        $data = $request->validate([
            'category_id' => ['sometimes', 'integer', 'exists:categories,id'],
            'name' => ['sometimes', 'string', 'max:150'],
            'description' => ['nullable', 'string'],
            'total_units' => ['sometimes', 'integer', 'min:1'],
        ]);

        $rented = $article->total_units - $article->available_units;

        if (isset($data['total_units'])) {
            if ($data['total_units'] < $rented) {
                return response()->json([
                    'message' => 'El total de unidades no puede ser menor a las unidades alquiladas.',
                    'errors' => (object) [],
                ], 422);
            }
            $data['available_units'] = $data['total_units'] - $rented;
        }

        $article->update($data);

        return response()->json(['data' => $article]);
    }

    public function destroy(int $id): JsonResponse
    {
        $article = Article::findOrFail($id);

        $rented = $article->total_units - $article->available_units;
        if ($rented > 0) {
            return response()->json([
                'message' => 'No se puede dar de baja un artículo con unidades sin devolver.',
                'errors' => (object) [],
            ], 422);
        }

        $article->delete();

        return response()->json(['message' => 'El artículo fue dado de baja.', 'data' => $article]);
    }
}
