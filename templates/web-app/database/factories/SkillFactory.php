<?php

namespace Database\Factories;

use App\Models\Skill;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Skill>
 */
class SkillFactory extends Factory
{
    protected $model = Skill::class;

    /** @return array<string, mixed> */
    public function definition(): array
    {
        $name = fake()->unique()->word();

        return [
            'name' => $name,
            'name_normalized' => Skill::normalizeName($name),
            'status' => Skill::STATUS_APPROVED,
        ];
    }

    public function pending(): static
    {
        return $this->state(fn () => ['status' => Skill::STATUS_PENDING]);
    }
}
