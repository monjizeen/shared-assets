<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\WorkExperience;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<WorkExperience>
 */
class WorkExperienceFactory extends Factory
{
    protected $model = WorkExperience::class;

    /** @return array<string, mixed> */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'company' => fake()->company(),
            'title' => fake()->jobTitle(),
            'years' => fake()->numberBetween(1, 15),
            'website' => fake()->url(),
            'sort_order' => 0,
        ];
    }
}
