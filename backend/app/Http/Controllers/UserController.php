<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\User;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $validated = $request->validate([
            'per_page' => ['nullable', 'numeric', 'between:0,1000'],
        ]);

        $authUser = auth()->user();

        // if user is not admin, abort with HTTP Status 403 (Unauthorized)
        if (!$authUser->is_admin) {
            abort(403);
        }

        // paginate to be safe and give better experience for frontends as data gets larger
        $paginatedUsers = User::paginate($validated['per_page'] ?? 15);

        return response()->json($paginatedUsers);
    }
}
