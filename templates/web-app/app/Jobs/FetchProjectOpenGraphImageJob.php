<?php

namespace App\Jobs;

use App\Models\Project;
use App\Services\Metadata\OpenGraphFetcher;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class FetchProjectOpenGraphImageJob implements ShouldQueue
{
    use Queueable;

    public function __construct(public int $projectId) {}

    public function handle(OpenGraphFetcher $fetcher): void
    {
        $project = Project::query()->find($this->projectId);
        if ($project === null) {
            return;
        }

        $imageUrl = $fetcher->fetchImageUrl((string) $project->link);
        if ($imageUrl !== null) {
            $project->forceFill(['og_image_url' => mb_substr($imageUrl, 0, 2048)])->save();
        }
    }
}
