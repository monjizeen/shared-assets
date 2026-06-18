<?php

namespace App\Http\Requests\WorkExperience;

use Illuminate\Foundation\Http\FormRequest;

class StoreWorkExperienceRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'company' => trim((string) $this->input('company')),
            'title' => trim((string) $this->input('title')),
            'years' => (int) $this->input('years'),
            'website' => $this->filled('website') ? trim((string) $this->input('website')) : null,
            'sort_order' => (int) $this->input('sort_order', 0),
        ]);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'company' => ['required', 'string', 'max:255'],
            'title' => ['required', 'string', 'max:255'],
            'years' => ['required', 'integer', 'min:0', 'max:80'],
            'website' => ['nullable', 'url', 'max:2048'],
            'sort_order' => ['nullable', 'integer', 'min:0'],
        ];
    }

    /** @return array<string, mixed> */
    public function payload(): array
    {
        return $this->validated();
    }
}
