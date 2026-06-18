<?php

namespace Database\Factories;

use App\Models\Availability;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Availability>
 */
class AvailabilityFactory extends Factory
{
    protected $model = Availability::class;

    /** @return array<string, mixed> */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'type' => Availability::TYPE_HOURLY,
            'is_active' => true,
            'hourly_rate' => fake()->randomFloat(2, 20, 200),
        ];
    }
}
