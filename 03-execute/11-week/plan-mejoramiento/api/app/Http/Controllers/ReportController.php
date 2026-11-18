<?php

namespace App\Http\Controllers;

use App\Models\RentalLine;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    public function mostRequested(Request $request): JsonResponse
    {
        $query = RentalLine::query()
            ->join('rentals', 'rentals.id', '=', 'rental_lines.rental_id')
            ->join('articles', 'articles.id', '=', 'rental_lines.article_id')
            ->select(
                'rental_lines.article_id',
                'rental_lines.article_reference as reference',
                'rental_lines.article_name as name',
                DB::raw('SUM(rental_lines.quantity) as total_quantity')
            )
            ->groupBy('rental_lines.article_id', 'rental_lines.article_reference', 'rental_lines.article_name')
            ->orderByDesc('total_quantity');

        if ($request->filled('from')) {
            $query->where('rentals.rented_at', '>=', $request->input('from'));
        }
        if ($request->filled('to')) {
            $query->where('rentals.rented_at', '<=', $request->input('to'));
        }
        if ($request->filled('category')) {
            $query->where('articles.category_id', $request->integer('category'));
        }

        $query->limit($request->integer('limit', 10));

        return response()->json(['data' => $query->get()]);
    }
}
