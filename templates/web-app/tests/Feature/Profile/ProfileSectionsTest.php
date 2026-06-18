<?php

namespace Tests\Feature\Profile;

use App\Models\Availability;
use App\Models\Certificate;
use App\Models\Project;
use App\Models\Skill;
use App\Models\User;
use App\Models\WorkExperience;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProfileSectionsTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_crud_profile_sections(): void
    {
        $user = User::factory()->create();
        $other = User::factory()->create();
        $skill = Skill::factory()->create();

        $this->actingAs($user)
            ->patch('/profile/personal', [
                'citizenship' => 'Jordan',
                'residence_country' => 'UAE',
            ])
            ->assertRedirect();

        $user->refresh();
        $this->assertSame('Jordan', $user->citizenship);

        $this->actingAs($user)
            ->post('/profile/experiences', [
                'company' => 'Acme',
                'title' => 'Engineer',
                'years' => 3,
                'website' => 'https://acme.test',
            ])
            ->assertRedirect();

        $experience = WorkExperience::query()->where('user_id', $user->id)->first();
        $this->assertNotNull($experience);

        $this->actingAs($user)
            ->post('/profile/projects', [
                'title' => 'Portfolio',
                'link' => 'https://portfolio.test',
                'description' => 'My work',
                'skill_ids' => [$skill->id],
            ])
            ->assertRedirect();

        $project = Project::query()->where('user_id', $user->id)->first();
        $this->assertNotNull($project);
        $this->assertTrue($project->skills()->where('skills.id', $skill->id)->exists());

        $this->actingAs($user)
            ->post('/profile/certificates', [
                'title' => 'AWS Certified',
                'link' => 'https://aws.amazon.com/cert',
            ])
            ->assertRedirect();

        $this->assertSame(1, Certificate::query()->where('user_id', $user->id)->count());

        $this->actingAs($user)
            ->post('/profile/skills', ['skill_ids' => [$skill->id]])
            ->assertRedirect();

        $this->assertTrue($user->skills()->where('skills.id', $skill->id)->exists());

        $this->actingAs($user)
            ->post('/profile/availabilities', [
                'type' => Availability::TYPE_HOURLY,
                'hourly_rate' => 75,
            ])
            ->assertRedirect();

        $this->assertSame(1, Availability::query()->where('user_id', $user->id)->count());

        $this->actingAs($other)
            ->delete('/profile/experiences/'.$experience->id)
            ->assertForbidden();
    }
}
