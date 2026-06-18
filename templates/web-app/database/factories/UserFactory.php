<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<User>
 */
class UserFactory extends Factory
{
    protected $model = User::class;

    /** @return array<string, mixed> */
    public function definition(): array
    {
        return [
            'username' => fake()->unique()->userName(),
            'name' => fake()->name(),
            'first_name' => fake()->firstName(),
            'last_name' => fake()->lastName(),
            'email' => fake()->unique()->safeEmail(),
            'avatar_url' => null,
            'citizenship' => fake()->country(),
            'residence_country' => fake()->country(),
            'global_role' => User::ROLE_MEMBER,
            'is_profile_complete' => false,
            'is_featured' => false,
        ];
    }

    public function admin(): static
    {
        return $this->state(fn () => ['global_role' => User::ROLE_ADMIN]);
    }

    public function complete(): static
    {
        return $this->state(fn () => ['is_profile_complete' => true]);
    }

    public function featured(): static
    {
        return $this->state(fn () => [
            'is_profile_complete' => true,
            'is_featured' => true,
            'featured_sort_order' => 1,
        ]);
    }

    public function suspended(): static
    {
        return $this->state(fn () => ['suspended_at' => now()]);
    }

    public function withoutUsername(): static
    {
        return $this->state(fn () => ['username' => null]);
    }
}
