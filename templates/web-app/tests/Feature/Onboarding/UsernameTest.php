<?php

namespace Tests\Feature\Onboarding;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UsernameTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_must_pick_unique_username(): void
    {
        User::factory()->create(['username' => 'taken']);
        $user = User::factory()->withoutUsername()->create();

        $this->actingAs($user)
            ->post('/onboarding', ['username' => 'taken'])
            ->assertSessionHasErrors('username');

        $this->actingAs($user)
            ->post('/onboarding', ['username' => 'fresh_user'])
            ->assertRedirect(route('dashboard'));

        $user->refresh();
        $this->assertSame('fresh_user', $user->username);
    }

    public function test_onboarding_skipped_when_username_exists(): void
    {
        $user = User::factory()->create(['username' => 'ready']);

        $this->actingAs($user)
            ->get('/onboarding')
            ->assertRedirect(route('dashboard'));
    }
}
