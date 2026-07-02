<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Socialite\Facades\Socialite;
use Laravel\Socialite\Two\User as SocialiteOAuthUser;
use Tests\TestCase;

class GoogleOAuthTest extends TestCase
{
    use RefreshDatabase;

    private function socialiteUser(array $raw, array $mapped): SocialiteOAuthUser
    {
        return (new SocialiteOAuthUser)->setRaw($raw)->map($mapped);
    }

    public function test_google_redirect_when_not_configured(): void
    {
        config([
            'services.google.client_id' => '',
            'services.google.client_secret' => '',
        ]);

        $this->get('/auth/google')
            ->assertRedirect(route('login'))
            ->assertSessionHas('error');

        $this->assertGuest();
    }

    public function test_google_callback_creates_new_user_with_open_registration(): void
    {
        config([
            'services.google.client_id' => 'test-id',
            'services.google.client_secret' => 'test-secret',
        ]);

        $socialUser = $this->socialiteUser(
            ['given_name' => 'New', 'family_name' => 'User', 'email' => 'newuser@example.com'],
            ['id' => 'sub-new', 'name' => 'New User', 'email' => 'newuser@example.com', 'avatar' => null],
        );

        Socialite::shouldReceive('driver')->once()->with('google')->andReturnSelf();
        Socialite::shouldReceive('user')->once()->andReturn($socialUser);

        $this->get('/auth/google/callback')
            ->assertRedirect(route('dashboard'));

        $this->assertAuthenticated();
        $this->assertDatabaseHas('users', ['email' => 'newuser@example.com']);
    }

    public function test_google_callback_redirects_existing_user_to_dashboard(): void
    {
        config([
            'services.google.client_id' => 'test-id',
            'services.google.client_secret' => 'test-secret',
        ]);

        $user = User::factory()->create(['email' => 'existing@example.com']);

        $socialUser = $this->socialiteUser(
            ['given_name' => 'Ex', 'family_name' => 'User', 'email' => 'existing@example.com'],
            ['id' => 'sub-ex', 'name' => 'Ex User', 'email' => 'existing@example.com', 'avatar' => null],
        );

        Socialite::shouldReceive('driver')->once()->with('google')->andReturnSelf();
        Socialite::shouldReceive('user')->once()->andReturn($socialUser);

        $this->get('/auth/google/callback')
            ->assertRedirect(route('dashboard'));

        $this->assertAuthenticatedAs($user);
    }

    public function test_suspended_user_cannot_sign_in(): void
    {
        config([
            'services.google.client_id' => 'test-id',
            'services.google.client_secret' => 'test-secret',
        ]);

        User::factory()->suspended()->create(['email' => 'suspended@example.com']);

        $socialUser = $this->socialiteUser(
            ['email' => 'suspended@example.com'],
            ['id' => 'sub-sus', 'email' => 'suspended@example.com', 'name' => 'Suspended'],
        );

        Socialite::shouldReceive('driver')->once()->with('google')->andReturnSelf();
        Socialite::shouldReceive('user')->once()->andReturn($socialUser);

        $this->get('/auth/google/callback')
            ->assertRedirect(route('login'))
            ->assertSessionHas('error');

        $this->assertGuest();
    }

    public function test_platform_admin_email_gets_admin_role_on_first_login(): void
    {
        config([
            'services.google.client_id' => 'test-id',
            'services.google.client_secret' => 'test-secret',
            'platform.admin_emails' => ['admin-bootstrap@example.com'],
        ]);

        $socialUser = $this->socialiteUser(
            ['email' => 'admin-bootstrap@example.com'],
            ['id' => 'sub-admin', 'email' => 'admin-bootstrap@example.com', 'name' => 'Admin'],
        );

        Socialite::shouldReceive('driver')->once()->with('google')->andReturnSelf();
        Socialite::shouldReceive('user')->once()->andReturn($socialUser);

        $this->get('/auth/google/callback')->assertRedirect(route('dashboard'));

        $this->assertDatabaseHas('users', [
            'email' => 'admin-bootstrap@example.com',
            'global_role' => User::ROLE_ADMIN,
        ]);
    }
}
