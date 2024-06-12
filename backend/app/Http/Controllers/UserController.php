<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\User;

class UserController extends Controller
{
    public function index()
    {
        $authUser = auth()->user();

        // if user is not admin, abort with HTTP Status 403 (Unauthorized)
        if (!$authUser->is_admin) {
            abort(403);
        }

        // paginate to be safe and give better experience for frontends as data gets larger
        $paginatedUsers = User::paginate();

        return response()->json($paginatedUsers);
    }
}
