<?php

namespace App\Support;

use App\Models\User;

final class PlatformAdminSync
{
    /** @var list<string> */
    public const BOOTSTRAP_ADMIN_EMAILS = [
        'omaronweb@gmail.com',
    ];

    /** @return list<string> */
    public static function adminEmails(): array
    {
        $fromConfig = config('platform.admin_emails', []);

        return array_values(array_unique(array_merge(
            self::BOOTSTRAP_ADMIN_EMAILS,
            is_array($fromConfig) ? $fromConfig : [],
        )));
    }

    public static function normalizedEmail(string $email): string
    {
        return strtolower(trim($email));
    }

    public static function isPlatformAdminEmail(string $email): bool
    {
        return in_array(self::normalizedEmail($email), self::adminEmails(), true);
    }

    public static function ensureUpgrade(User $user): void
    {
        if (! self::isPlatformAdminEmail((string) $user->email)) {
            return;
        }

        if ($user->global_role !== User::ROLE_ADMIN) {
            $user->forceFill(['global_role' => User::ROLE_ADMIN])->save();
        }
    }
}
