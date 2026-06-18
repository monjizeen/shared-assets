<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateUserAdminRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->isAdmin() ?? false;
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('action')) {
            $this->merge(['action' => trim((string) $this->input('action'))]);
        }
        if ($this->has('is_profile_complete')) {
            $this->merge(['is_profile_complete' => filter_var($this->input('is_profile_complete'), FILTER_VALIDATE_BOOLEAN)]);
        }
        if ($this->has('featured_sort_order')) {
            $this->merge(['featured_sort_order' => (int) $this->input('featured_sort_order')]);
        }
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'action' => ['required', 'string', Rule::in([
                'promote', 'demote', 'suspend', 'unsuspend',
                'mark_complete', 'mark_incomplete', 'feature', 'unfeature',
            ])],
            'is_profile_complete' => ['sometimes', 'boolean'],
            'featured_sort_order' => ['nullable', 'integer', 'min:0'],
        ];
    }

    public function action(): string
    {
        return (string) $this->validated('action');
    }
}
