<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property string|null $username
 * @property string|null $name
 * @property string|null $email
 * @property string|null $avatar_url
 * @property string|null $citizenship
 * @property string|null $residence_country
 * @property string $global_role
 * @property Carbon|null $suspended_at
 * @property bool $is_profile_complete
 * @property bool $is_featured
 * @property int|null $featured_sort_order
 */
class User extends Authenticatable
{
    public const ROLE_ADMIN = 'admin';

    public const ROLE_MEMBER = 'member';

    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable;

    protected $fillable = [
        'username', 'name', 'first_name', 'last_name', 'email',
        'avatar_url', 'citizenship', 'residence_country', 'global_role',
        'suspended_at', 'is_profile_complete', 'is_featured', 'featured_sort_order',
        'last_login_at',
    ];

    protected $hidden = [
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'last_login_at' => 'datetime',
            'suspended_at' => 'datetime',
            'is_profile_complete' => 'boolean',
            'is_featured' => 'boolean',
            'featured_sort_order' => 'integer',
        ];
    }

    /** @param Builder<User> $query */
    public function scopeDirectoryVisible(Builder $query): Builder
    {
        return $query
            ->where('is_profile_complete', true)
            ->whereNull('suspended_at');
    }

    /** @param Builder<User> $query */
    public function scopeFeatured(Builder $query): Builder
    {
        return $query
            ->directoryVisible()
            ->where('is_featured', true)
            ->orderBy('featured_sort_order')
            ->orderBy('id');
    }

    /** @return HasMany<WorkExperience, $this> */
    public function workExperiences(): HasMany
    {
        return $this->hasMany(WorkExperience::class)->orderBy('sort_order')->orderBy('id');
    }

    /** @return HasMany<Project, $this> */
    public function projects(): HasMany
    {
        return $this->hasMany(Project::class)->orderBy('sort_order')->orderBy('id');
    }

    /** @return HasMany<Certificate, $this> */
    public function certificates(): HasMany
    {
        return $this->hasMany(Certificate::class)->orderBy('sort_order')->orderBy('id');
    }

    /** @return BelongsToMany<Skill, $this> */
    public function skills(): BelongsToMany
    {
        return $this->belongsToMany(Skill::class, 'user_skill')->withTimestamps();
    }

    /** @return HasMany<Availability, $this> */
    public function availabilities(): HasMany
    {
        return $this->hasMany(Availability::class);
    }

    public function isAdmin(): bool
    {
        return $this->global_role === self::ROLE_ADMIN;
    }

    public function isSuspended(): bool
    {
        return $this->suspended_at !== null;
    }

    public function isDirectoryVisible(): bool
    {
        return $this->is_profile_complete && ! $this->isSuspended();
    }

    public function needsOnboarding(): bool
    {
        return $this->username === null || trim((string) $this->username) === '';
    }

    public function resolvedDisplayName(): string
    {
        $name = trim((string) ($this->name ?? ''));

        return $name !== '' ? $name : (string) ($this->username ?? $this->email ?? 'User');
    }

    /** @return array<string, mixed> */
    public function toInertiaSummary(): array
    {
        return [
            'id' => (int) $this->id,
            'username' => $this->username,
            'name' => $this->resolvedDisplayName(),
            'email' => $this->email,
            'photo_url' => $this->avatar_url,
            'citizenship' => $this->citizenship,
            'residence_country' => $this->residence_country,
            'is_profile_complete' => (bool) $this->is_profile_complete,
            'is_featured' => (bool) $this->is_featured,
            'skills' => $this->relationLoaded('skills')
                ? $this->skills->map(fn (Skill $skill) => $skill->toInertiaSummary())->values()->all()
                : [],
            'availabilities' => $this->relationLoaded('availabilities')
                ? $this->availabilities->map(fn (Availability $a) => $a->toInertiaSummary())->values()->all()
                : [],
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
