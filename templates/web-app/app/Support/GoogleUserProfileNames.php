<?php

namespace App\Support;

use Laravel\Socialite\AbstractUser;

final class GoogleUserProfileNames
{
    /**
     * @return array{first_name: ?string, last_name: ?string, name: ?string}
     */
    public static function extract(AbstractUser $googleUser): array
    {
        $raw = $googleUser->getRaw();

        $first = self::trimOrNull(isset($raw['given_name']) && is_string($raw['given_name']) ? $raw['given_name'] : null);
        $last = self::trimOrNull(isset($raw['family_name']) && is_string($raw['family_name']) ? $raw['family_name'] : null);

        if ($first === null && $last === null) {
            $full = self::trimOrNull($googleUser->getName());
            if ($full !== null) {
                $parts = preg_split('/\s+/u', $full, 2, PREG_SPLIT_NO_EMPTY) ?: [];
                $first = isset($parts[0]) ? self::trimOrNull($parts[0]) : null;
                $last = isset($parts[1]) ? self::trimOrNull($parts[1]) : null;
            }
        }

        $composed = trim(implode(' ', array_filter([$first ?? '', $last ?? ''], fn (string $s): bool => $s !== '')));
        $name = $composed !== '' ? $composed : self::trimOrNull($googleUser->getName());

        return [
            'first_name' => $first,
            'last_name' => $last,
            'name' => $name,
        ];
    }

    private static function trimOrNull(?string $value): ?string
    {
        if ($value === null) {
            return null;
        }

        $s = trim($value);

        return $s === '' ? null : $s;
    }
}
