<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class MergeSkillsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->isAdmin() ?? false;
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'target_skill_id' => (int) $this->input('target_skill_id'),
            'source_skill_id' => (int) $this->input('source_skill_id'),
        ]);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'target_skill_id' => ['required', 'integer', Rule::exists('skills', 'id')],
            'source_skill_id' => ['required', 'integer', Rule::exists('skills', 'id'), 'different:target_skill_id'],
        ];
    }
}
