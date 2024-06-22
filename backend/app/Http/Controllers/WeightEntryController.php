<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\WeightEntry;

class WeightEntryController extends Controller
{
    public function index(Request $request)
    {
        $validated = $request->validate([
            'per_page' => ['nullable', 'numeric', 'between:0,1000'],
        ]);
    
        $authUser = auth()->user();

        $paginatedWeightEntries = $authUser->weightEntries()->latest()->paginate($validated['per_page'] ?? 15);

        return response()->json($paginatedWeightEntries);
    }

    public function store(Request $request)
    {
        $authUser = auth()->user();

        $validated = $request->validate([
            'kg' => ['required', 'numeric', 'between:0.00,2000.0'],
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $weightEntry = $authUser->weightEntries()->create([
            'kg' => $validated['kg'],
            'notes' => $validated['notes'],
        ]);

        return response()->json(['data' => $weightEntry]);
    }

    public function show(string $id)
    {
        $authUser = auth()->user();

        $weightEntry = WeightEntry::where('id', $id)->firstOrFail();

        // check if user is trying to access another user's data. If yes, abort with 403 Unauthorized error
        if ($weightEntry->user_id !== $authUser->id) {
            abort(403);
        }

        return response()->json(['data' => $weightEntry]);
    }

    public function update(Request $request, string $id)
    {
        $authUser = auth()->user();

        $weightEntry = WeightEntry::where('id', $id)->firstOrFail();

        // check if user is trying to access another user's data. If yes, abort with 403 Unauthorized error
        if ($weightEntry->user_id !== $authUser->id) {
            abort(403);
        }

        $validated = $request->validate([
            'kg' => ['required', 'numeric', 'between:0.00,2000.0'],
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $weightEntry->update([
            'kg' => $validated['kg'],
            'notes' => $validated['notes'],
        ]);

        return response()->json(['data' => $weightEntry]);
    }

    public function destroy(string $id)
    {
        $authUser = auth()->user();

        $weightEntry = WeightEntry::where('id', $id)->firstOrFail();

        // check if user is trying to access another user's data. If yes, abort with 403 Unauthorized error
        if ($weightEntry->user_id !== $authUser->id) {
            abort(403);
        }

        $weightEntry->delete();

        return response()->json([], 204);
    }
}
