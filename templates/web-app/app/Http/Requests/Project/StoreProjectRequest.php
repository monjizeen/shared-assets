<?php

namespace App\Http\Requests\Project;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProjectRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    protected function prepareForValidation(): void
    {
        $skillIds = $this->input('skill_ids', []);
        if (! is_array($skillIds)) {
            $skillIds = [];
        }

        $this->merge([
            'title' => trim((string) $this->input('title')),
            'link' => trim((string) $this->input('link')),
            'description' => trim((string) $this->input('description')),
            'sort_order' => (int) $this->input('sort_order', 0),
            'skill_ids' => array_values(array_unique(array_map('intval', $skillIds))),
        ]);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'link' => ['required', 'url', 'max:2048'],
            'description' => ['required', 'string', 'max:5000'],
            'sort_order' => ['nullable', 'integer', 'min:0'],
            'skill_ids' => ['nullable', 'array'],
            'skill_ids.*' => ['integer', Rule::exists('skills', 'id')->where('status', 'approved')],
        ];
    }

    /** @return array<string, mixed> */
    public function payload(): array
    {
        return $this->validated();
    }

    /** @return list<int> */
    public function skillIds(): array
    {
        return $this->input('skill_ids', []);
    }
}
