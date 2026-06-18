<?php

namespace Tests\Feature\Admin;

use App\Models\User;
use App\Services\Admin\FeaturedProfileService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FeaturedProfileLimitTest extends TestCase
{
    use RefreshDatabase;

    public function test_cannot_feature_more_than_twenty_profiles(): void
    {
        $admin = User::factory()->admin()->create();

        User::factory()->count(FeaturedProfileService::MAX_FEATURED)->featured()->create();

        $candidate = User::factory()->complete()->create();

        $this->actingAs($admin)
            ->patch('/admin/users/'.$candidate->id, ['action' => 'feature'])
            ->assertSessionHasErrors();

        $candidate->refresh();
        $this->assertFalse($candidate->is_featured);
    }
}
