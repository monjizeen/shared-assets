<?php

namespace Tests\Feature\Skill;

use App\Models\Skill;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SkillApprovalWorkflowTest extends TestCase
{
    use RefreshDatabase;

    public function test_suggest_approve_attach_workflow(): void
    {
        $user = User::factory()->create();
        $admin = User::factory()->admin()->create();

        $this->actingAs($user)
            ->post('/profile/skills/suggest', ['name' => 'Rust'])
            ->assertRedirect();

        $skill = Skill::query()->where('name_normalized', 'rust')->first();
        $this->assertNotNull($skill);
        $this->assertSame(Skill::STATUS_PENDING, $skill->status);
        $this->assertFalse($user->skills()->where('skills.id', $skill->id)->exists());

        $this->actingAs($admin)
            ->patch('/admin/skills/'.$skill->id.'/approve')
            ->assertRedirect();

        $skill->refresh();
        $this->assertSame(Skill::STATUS_APPROVED, $skill->status);
        $this->assertTrue($user->fresh()->skills()->where('skills.id', $skill->id)->exists());

        $this->actingAs($user)
            ->post('/profile/skills', ['skill_ids' => [$skill->id]])
            ->assertRedirect();
    }

    public function test_reject_removes_pending_skill(): void
    {
        $admin = User::factory()->admin()->create();
        $skill = Skill::factory()->pending()->create(['name' => 'Elixir']);

        $this->actingAs($admin)
            ->patch('/admin/skills/'.$skill->id.'/reject')
            ->assertRedirect();

        $this->assertDatabaseMissing('skills', ['id' => $skill->id]);
    }
}
