<?php

namespace App\Http\Controllers;

use App\Models\Advisor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $advisor = Advisor::where('email', $credentials['email'])->first();

        if ($advisor === null || ! Hash::check($credentials['password'], $advisor->password)) {
            return response()->json([
                'message' => 'Las credenciales no son válidas.',
                'errors' => (object) [],
            ], 401);
        }

        $token = $advisor->createToken('api')->plainTextToken;

        return response()->json([
            'token' => $token,
            'advisor' => [
                'id' => $advisor->id,
                'name' => $advisor->name,
                'email' => $advisor->email,
            ],
        ], 200);
    }
}
