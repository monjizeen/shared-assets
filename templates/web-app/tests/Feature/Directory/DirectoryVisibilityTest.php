<?php

namespace Tests\Feature\Directory;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DirectoryVisibilityTest extends TestCase
{
    use RefreshDatabase;

    public function test_guests_see_home_but_not_directory(): void
    {
        User::factory()->featured()->create(['name' => 'Featured One']);

        $this->get('/')
            ->assertOk()
            ->assertInertia(fn ($page) => $page
                ->component('home/HomePage')
                ->has('featured_profiles', 1));

        $this->get('/directory')->assertRedirect(route('login'));
    }

    public function test_auth_user_sees_only_complete_profiles_in_directory(): void
    {
        $viewer = User::factory()->create();
        User::factory()->complete()->create(['name' => 'Complete User']);
        User::factory()->create(['name' => 'Incomplete User', 'is_profile_complete' => false]);

        $this->actingAs($viewer)
            ->get('/directory')
            ->assertOk()
            ->assertInertia(fn ($page) => $page
                ->component('directory/DirectoryPage')
                ->has('profiles', 1));
    }
}
