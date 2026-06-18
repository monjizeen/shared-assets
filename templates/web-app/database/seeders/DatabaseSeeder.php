<?php

namespace Database\Seeders;

use App\Models\User;
use App\Support\PlatformAdminSync;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        foreach (PlatformAdminSync::adminEmails() as $email) {
            User::query()->firstOrCreate(
                ['email' => $email],
                [
                    'username' => strstr($email, '@', true) ?: 'admin',
                    'name' => 'Admin',
                    'global_role' => User::ROLE_ADMIN,
                    'is_profile_complete' => true,
                ],
            );
        }

        $this->call(SkillSeeder::class);
    }
}
