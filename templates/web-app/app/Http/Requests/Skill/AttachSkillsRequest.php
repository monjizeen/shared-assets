<?php

namespace App\Http\Requests\Skill;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class AttachSkillsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    protected function prepareForValidation(): void
    {
        $ids = $this->input('skill_ids', []);
        if (! is_array($ids)) {
            $ids = [];
        }

        $this->merge([
            'skill_ids' => array_values(array_unique(array_map('intval', $ids))),
        ]);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'skill_ids' => ['required', 'array', 'min:1'],
            'skill_ids.*' => ['integer', Rule::exists('skills', 'id')->where('status', 'approved')],
        ];
    }

    /** @return list<int> */
    public function skillIds(): array
    {
        return $this->input('skill_ids', []);
    }
}
