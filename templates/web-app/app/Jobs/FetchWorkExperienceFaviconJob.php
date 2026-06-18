<?php

namespace App\Jobs;

use App\Models\WorkExperience;
use App\Services\Metadata\FaviconFetcher;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class FetchWorkExperienceFaviconJob implements ShouldQueue
{
    use Queueable;

    public function __construct(public int $workExperienceId) {}

    public function handle(FaviconFetcher $fetcher): void
    {
        $experience = WorkExperience::query()->find($this->workExperienceId);
        if ($experience === null || $experience->website === null) {
            return;
        }

        $faviconUrl = $fetcher->fetchFaviconUrl((string) $experience->website);
        if ($faviconUrl !== null) {
            $experience->forceFill(['favicon_url' => mb_substr($faviconUrl, 0, 2048)])->save();
        }
    }
}
