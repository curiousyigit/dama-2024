<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Middleware\GuestApi;

Route::middleware(GuestApi::class)->group(function () {
    Route::post('/auth/token', [\App\Http\Controllers\AuthController::class, 'createToken']);
    Route::post('/auth/register', [\App\Http\Controllers\AuthController::class, 'register']);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/auth/user', [\App\Http\Controllers\AuthController::class, 'showAuthenticatedUser']);
    Route::delete('/auth/tokens', [\App\Http\Controllers\AuthController::class, 'destroyTokens']);

    Route::get('/users', [\App\Http\Controllers\UserController::class, 'index']);

    Route::apiResource('/weight-entries', \App\Http\Controllers\WeightEntryController::class);
});
