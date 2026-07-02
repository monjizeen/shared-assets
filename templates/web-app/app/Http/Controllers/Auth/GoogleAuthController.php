<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Services\Auth\GoogleSignInService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Laravel\Socialite\AbstractUser as SocialiteAbstractUser;
use Laravel\Socialite\Facades\Socialite;
use Laravel\Socialite\Two\AbstractProvider;
use RuntimeException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Throwable;

class GoogleAuthController extends Controller
{
    public function __construct(private GoogleSignInService $googleSignIn) {}

    public function redirect()
    {
        $clientId = trim((string) config('services.google.client_id'));
        $clientSecret = trim((string) config('services.google.client_secret'));

        if ($clientId === '' || $clientSecret === '') {
            return redirect()
                ->route('login')
                ->with('error', 'Google sign-in is not configured.');
        }

        return $this->googleOAuth2Provider()
            ->redirectUrl((string) config('services.google.redirect'))
            ->redirect();
    }

    public function callback()
    {
        try {
            $googleUser = Socialite::driver('google')->user();
        } catch (Throwable $e) {
            report($e);

            return redirect()
                ->route('login')
                ->with('error', 'Google sign-in failed. Please try again.');
        }

        if (! $googleUser instanceof SocialiteAbstractUser) {
            report(new RuntimeException('Google OAuth user must be a Socialite AbstractUser.'));

            return redirect()
                ->route('login')
                ->with('error', 'Google sign-in failed. Please try again.');
        }

        try {
            $user = $this->googleSignIn->resolveOrCreateUser($googleUser);
        } catch (HttpException $e) {
            return redirect()->route('login')->with('error', $e->getMessage());
        }

        Auth::login($user, true);

        if ($user->needsOnboarding() && Route::has('onboarding.show')) {
            return redirect()->route('onboarding.show');
        }

        return redirect()->route('dashboard');
    }

    private function googleOAuth2Provider(): AbstractProvider
    {
        $provider = Socialite::driver('google');

        if (! $provider instanceof AbstractProvider) {
            throw new RuntimeException('Google OAuth driver must be an OAuth2 AbstractProvider.');
        }

        return $provider;
    }
}
