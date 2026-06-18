<?php

namespace Tests\Feature\Directory;

use App\Models\Skill;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DirectoryFilterTest extends TestCase
{
    use RefreshDatabase;

    public function test_directory_filters_and_sorts(): void
    {
        $viewer = User::factory()->create();
        $php = Skill::factory()->create(['name' => 'PHP']);
        $vue = Skill::factory()->create(['name' => 'Vue']);

        $alice = User::factory()->complete()->create([
            'name' => 'Alice',
            'citizenship' => 'Jordan',
            'residence_country' => 'UAE',
            'created_at' => now()->subDay(),
        ]);
        $bob = User::factory()->complete()->create([
            'name' => 'Bob',
            'citizenship' => 'Egypt',
            'residence_country' => 'KSA',
        ]);

        $alice->skills()->attach($php->id);
        $bob->skills()->attach($vue->id);

        $this->actingAs($viewer)
            ->get('/directory?citizenship=Jordan')
            ->assertOk()
            ->assertInertia(fn ($page) => $page
                ->has('profiles', 1)
                ->where('profiles.0.name', 'Alice'));

        $this->actingAs($viewer)
            ->get('/directory?skills[]='.$php->id)
            ->assertOk()
            ->assertInertia(fn ($page) => $page->has('profiles', 1));

        $this->actingAs($viewer)
            ->get('/directory?sort=created_at&direction=desc')
            ->assertOk()
            ->assertInertia(fn ($page) => $page
                ->where('profiles.0.name', 'Bob'));
    }
}
