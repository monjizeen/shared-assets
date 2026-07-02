<?php

namespace App\Services\Auth;

use App\Models\User;
use App\Support\GoogleUserProfileNames;
use App\Support\PlatformAdminSync;
use Laravel\Socialite\AbstractUser;
use Symfony\Component\HttpKernel\Exception\HttpException;

final class GoogleSignInService
{
    public function resolveOrCreateUser(AbstractUser $googleUser): User
    {
        $email = PlatformAdminSync::normalizedEmail((string) ($googleUser->getEmail() ?? ''));

        if ($email === '') {
            throw new HttpException(422, 'Google account has no email address.');
        }

        $existing = User::query()->where('email', $email)->first();

        if ($existing !== null) {
            if ($existing->isSuspended()) {
                throw new HttpException(403, 'Your account has been suspended.');
            }

            $this->syncProfileFromGoogle($existing, $googleUser);
            PlatformAdminSync::ensureUpgrade($existing);

            return $existing;
        }

        $names = GoogleUserProfileNames::extract($googleUser);

        $user = User::query()->create([
            'email' => $email,
            'email_verified_at' => now(),
            'name' => $names['name'],
            'first_name' => $names['first_name'],
            'last_name' => $names['last_name'],
            'avatar_url' => $googleUser->getAvatar(),
            'global_role' => User::ROLE_MEMBER,
            'last_login_at' => now(),
        ]);

        PlatformAdminSync::ensureUpgrade($user);

        return $user;
    }

    private function syncProfileFromGoogle(User $user, AbstractUser $googleUser): void
    {
        $names = GoogleUserProfileNames::extract($googleUser);

        $user->forceFill([
            'name' => $names['name'] ?? $user->name,
            'first_name' => $names['first_name'] ?? $user->first_name,
            'last_name' => $names['last_name'] ?? $user->last_name,
            'avatar_url' => $googleUser->getAvatar() ?? $user->avatar_url,
            'last_login_at' => now(),
        ])->save();
    }
}
