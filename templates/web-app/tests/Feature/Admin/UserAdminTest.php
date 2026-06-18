<?php

namespace Tests\Feature\Admin;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserAdminTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_can_manage_users(): void
    {
        $admin = User::factory()->admin()->create();
        $member = User::factory()->create();

        $this->actingAs($member)
            ->patch('/admin/users/'.$member->id, ['action' => 'mark_complete'])
            ->assertForbidden();

        $this->actingAs($admin)
            ->patch('/admin/users/'.$member->id, ['action' => 'mark_complete'])
            ->assertRedirect();

        $member->refresh();
        $this->assertTrue($member->is_profile_complete);

        $this->actingAs($admin)
            ->patch('/admin/users/'.$member->id, ['action' => 'promote'])
            ->assertRedirect();

        $this->assertTrue($member->fresh()->isAdmin());
    }
}
