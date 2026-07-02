<?php

namespace App\Http\Controllers;

use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Inertia\Response;

class HomeController extends Controller
{
    public function index(): Response|RedirectResponse
    {
        if (config('platform.auth_model') === 'closed' && ! Auth::check()) {
            return redirect()->route('login');
        }

        return Inertia::render('home/HomePage');
    }
}
