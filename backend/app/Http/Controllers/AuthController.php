<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;

use App\Models\User;

class AuthController extends Controller
{
    public function createToken(Request $request)
    {
        // reference: https://laravel.com/docs/11.x/sanctum

        $request->validate([
            'email' => ['required', 'email', 'max:255'],
            'password' => ['required', 'string', 'max:255'],
            'device_name' => ['required', 'string', 'max:255'],
        ]);
     
        $user = User::where('email', $request->email)->first();
     
        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => [__('auth.failed')],
            ]);
        }
     
        return response()->json(['token' => $user->createToken($request->device_name)->plainTextToken]);
    }

    public function destroyTokens(Request $request)
    {
        $authUser = auth()->user();

        $authUser->tokens()->delete();

        return response()->json([], 204);
    }

    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'string', 'confirmed', 'min:6', 'max:255'],
        ]);

        $user = new User;
        $user->name = $validated['name'];
        $user->email = $validated['email'];
        $user->password = bcrypt($validated['password']);
        $user->save();

        return response()->json(['data' => $user]);
    }

    public function showAuthenticatedUser()
    {
        $authUser = auth()->user();

        return response()->json(['data' => $authUser]);
    }
}
