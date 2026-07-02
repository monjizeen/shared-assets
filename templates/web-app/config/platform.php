<?php

return [
    'auth_model' => env('PLATFORM_AUTH_MODEL', 'open'),

    'admin_emails' => array_values(array_filter(array_map(
        static fn (string $email): string => strtolower(trim($email)),
        explode(',', (string) env('PLATFORM_ADMIN_EMAILS', '')),
    ))),
];
