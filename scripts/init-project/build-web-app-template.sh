#!/usr/bin/env bash
# Build shared-assets/templates/web-app from kawader (strip domain) + monjizeen design-system core.
# Maintainer script — run after kawader or design-system conventions change.
# Usage: build-web-app-template.sh [monorepo-root]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONO_ROOT="${1:-$(cd "${SCRIPT_DIR}/../../.." && pwd)}"
KAWADER="${MONO_ROOT}/kawader"
MONJIZEEN="${MONO_ROOT}/monjizeen"
TEMPLATE="${SCRIPT_DIR}/../../templates/web-app"
DESIGN_SRC="${SCRIPT_DIR}/../../templates/web-app-design"

if [[ ! -d "${KAWADER}" ]]; then
  echo "error: kawader not found at ${KAWADER}" >&2
  exit 1
fi

if [[ ! -d "${MONJIZEEN}" ]]; then
  echo "error: monjizeen not found at ${MONJIZEEN}" >&2
  exit 1
fi

echo "build: clean ${TEMPLATE}"
rm -rf "${TEMPLATE}"
mkdir -p "${TEMPLATE}"

echo "build: rsync kawader base"
rsync -a \
  --exclude '.git' \
  --exclude 'database/database.sqlite' \
  --exclude 'node_modules' \
  --exclude 'vendor' \
  --exclude '.env' \
  --exclude 'public/hot' \
  --exclude '.phpunit.result.cache' \
  --exclude '.DS_Store' \
  --exclude '._*' \
  "${KAWADER}/" "${TEMPLATE}/"

echo "build: remove kawader domain code"
rm -rf \
  "${TEMPLATE}/app/Http/Controllers/Admin" \
  "${TEMPLATE}/app/Http/Controllers/Profile" \
  "${TEMPLATE}/app/Http/Controllers/DirectoryController.php" \
  "${TEMPLATE}/app/Http/Controllers/OnboardingController.php" \
  "${TEMPLATE}/app/Http/Requests/Profile" \
  "${TEMPLATE}/app/Http/Requests/Availability" \
  "${TEMPLATE}/app/Models/Availability.php" \
  "${TEMPLATE}/app/Models/Certificate.php" \
  "${TEMPLATE}/app/Models/Project.php" \
  "${TEMPLATE}/app/Models/Skill.php" \
  "${TEMPLATE}/app/Models/WorkExperience.php" \
  "${TEMPLATE}/app/Services" \
  "${TEMPLATE}/app/Support/ProfileInertiaPayload.php" \
  "${TEMPLATE}/app/Support/CountryOptions.php" \
  "${TEMPLATE}/resources/js/Pages/admin" \
  "${TEMPLATE}/resources/js/Pages/dashboard" \
  "${TEMPLATE}/resources/js/Pages/directory" \
  "${TEMPLATE}/resources/js/Pages/onboarding" \
  "${TEMPLATE}/resources/js/Pages/home" \
  "${TEMPLATE}/resources/js/components/ProfileCard.vue" \
  "${TEMPLATE}/database/migrations/"*availability* \
  "${TEMPLATE}/database/migrations/"*certificate* \
  "${TEMPLATE}/database/migrations/"*project* \
  "${TEMPLATE}/database/migrations/"*skill* \
  "${TEMPLATE}/database/migrations/"*work_experience* \
  "${TEMPLATE}/database/migrations/"*featured* \
  "${TEMPLATE}/database/migrations/"*complete* \
  "${TEMPLATE}/database/migrations/"*username* \
  "${TEMPLATE}/database/seeders/"*Skill* 2>/dev/null || true

rm -f "${TEMPLATE}/database/database.sqlite"

echo "build: copy design-system core from monjizeen"
mkdir -p "${DESIGN_SRC}/ui"
UI_COMPONENTS=(button card input label separator)
for c in "${UI_COMPONENTS[@]}"; do
  rm -rf "${DESIGN_SRC}/ui/${c}"
  cp -R "${MONJIZEEN}/resources/js/components/ui/${c}" "${DESIGN_SRC}/ui/${c}"
done
cp "${MONJIZEEN}/resources/js/lib/utils.js" "${DESIGN_SRC}/utils.js"

mkdir -p "${TEMPLATE}/resources/js/components/ui"
for c in "${UI_COMPONENTS[@]}"; do
  cp -R "${DESIGN_SRC}/ui/${c}" "${TEMPLATE}/resources/js/components/ui/${c}"
done
mkdir -p "${TEMPLATE}/resources/js/lib"
cp "${DESIGN_SRC}/utils.js" "${TEMPLATE}/resources/js/lib/utils.js"

if [[ -f "${SCRIPT_DIR}/../../templates/web-app-design/app-theme.css" ]]; then
  cp "${SCRIPT_DIR}/../../templates/web-app-design/app-theme.css" "${TEMPLATE}/resources/css/app-theme.css"
fi

echo "build: minimal routes and pages"
cat > "${TEMPLATE}/routes/web.php" <<'PHP'
<?php

use App\Http\Controllers\Auth\GoogleAuthController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\HomeController;
use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Http\Controllers\AuthenticatedSessionController;

Route::get('/', [HomeController::class, 'index'])->name('home');

Route::get('/login', [LoginController::class, 'show'])
    ->middleware('guest')
    ->name('login');

Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
    ->middleware('auth')
    ->name('logout');

Route::get('/auth/google', [GoogleAuthController::class, 'redirect'])->name('login.google');
Route::get('/auth/google/callback', [GoogleAuthController::class, 'callback'])->name('login.google.callback');

Route::middleware(['auth'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
});
PHP

cat > "${TEMPLATE}/app/Http/Controllers/HomeController.php" <<'PHP'
<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;

class HomeController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('home/HomePage');
    }
}
PHP

cat > "${TEMPLATE}/app/Http/Controllers/DashboardController.php" <<'PHP'
<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('dashboard/DashboardPage');
    }
}
PHP

mkdir -p "${TEMPLATE}/resources/js/Pages/home" "${TEMPLATE}/resources/js/Pages/dashboard"
cat > "${TEMPLATE}/resources/js/Pages/home/HomePage.vue" <<'VUE'
<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LogIn } from 'lucide-vue-next';
import { Link, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const user = computed(() => usePage().props.auth?.user);
</script>

<template>
    <AppLayout>
        <Card class="mx-auto max-w-lg">
            <CardHeader>
                <CardTitle>Welcome</CardTitle>
                <CardDescription>Org web app scaffold with shadcn-vue and Lucide icons.</CardDescription>
            </CardHeader>
            <CardContent class="flex flex-wrap gap-3">
                <Button v-if="user" as-child>
                    <Link :href="route('dashboard')">Open dashboard</Link>
                </Button>
                <Button v-else as-child>
                    <Link :href="route('login')">
                        <LogIn class="size-4" />
                        Sign in
                    </Link>
                </Button>
            </CardContent>
        </Card>
    </AppLayout>
</template>
VUE

cat > "${TEMPLATE}/resources/js/Pages/dashboard/DashboardPage.vue" <<'VUE'
<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LayoutDashboard } from 'lucide-vue-next';
import { usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const user = computed(() => usePage().props.auth?.user);
</script>

<template>
    <AppLayout>
        <Card>
            <CardHeader>
                <CardTitle class="flex items-center gap-2">
                    <LayoutDashboard class="size-5" />
                    Dashboard
                </CardTitle>
                <CardDescription>Signed in as {{ user?.email }}</CardDescription>
            </CardHeader>
            <CardContent>
                <p class="text-muted-foreground text-sm">Replace this shell with your product UI.</p>
            </CardContent>
        </Card>
    </AppLayout>
</template>
VUE

cat > "${TEMPLATE}/resources/js/Pages/auth/LoginPage.vue" <<'VUE'
<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LogIn } from 'lucide-vue-next';
</script>

<template>
    <AppLayout>
        <Card class="mx-auto max-w-md text-center">
            <CardHeader>
                <CardTitle>Sign in</CardTitle>
                <CardDescription>Continue with your Google account.</CardDescription>
            </CardHeader>
            <CardContent class="space-y-4">
                <p v-if="$page.props.flash?.error" class="text-destructive text-sm">
                    {{ $page.props.flash.error }}
                </p>
                <Button as-child class="w-full">
                    <a :href="route('login.google')">
                        <LogIn class="size-4" />
                        Continue with Google
                    </a>
                </Button>
            </CardContent>
        </Card>
    </AppLayout>
</template>
VUE

cat > "${TEMPLATE}/resources/js/Layouts/AppLayout.vue" <<'VUE'
<script setup>
import { Button } from '@/components/ui/button';
import { Link, usePage } from '@inertiajs/vue3';
import { LogOut } from 'lucide-vue-next';
import { computed } from 'vue';

const page = usePage();
const user = computed(() => page.props.auth?.user);
const appName = computed(() => page.props.app?.name ?? 'App');
</script>

<template>
    <div class="bg-background text-foreground min-h-screen">
        <header class="border-border border-b">
            <div class="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
                <Link :href="route('home')" class="text-lg font-semibold">{{ appName }}</Link>
                <nav class="flex items-center gap-2">
                    <Button v-if="user" variant="ghost" as-child>
                        <Link :href="route('dashboard')">Dashboard</Link>
                    </Button>
                    <Button v-if="!user" as-child>
                        <Link :href="route('login')">Sign in</Link>
                    </Button>
                    <Button v-else variant="ghost" as-child>
                        <Link :href="route('logout')" method="post" as="button">
                            <LogOut class="size-4" />
                            Sign out
                        </Link>
                    </Button>
                </nav>
            </div>
        </header>
        <main class="mx-auto max-w-6xl px-4 py-8">
            <slot />
        </main>
    </div>
</template>
VUE

cat > "${TEMPLATE}/docs/ARCHITECTURE.md" <<'MD'
# Web App Architecture

Generic monjizeen-dev web product scaffold.

## Stack

- Laravel 13, PHP 8.3+, SQLite (dev/CI)
- Inertia.js + Vue 3, Tailwind CSS v4, Vite
- **Design system:** shadcn-vue (Reka UI) + **Lucide** (`lucide-vue-next`)
- Google OAuth (Socialite), session guard

## Layering

1. **HTTP** — thin controllers in `app/Http/Controllers`
2. **Validation** — FormRequests in `app/Http/Requests`
3. **Services** — multi-step logic in `app/Services`
4. **Models** — Eloquent in `app/Models`
5. **UI** — Vue pages in `resources/js/Pages`, shadcn components in `resources/js/components/ui`

## Design system

- Add components: `npx shadcn-vue@latest add <component>` (from project root)
- Icons: import from `lucide-vue-next` only (org standard)
- Tokens: `resources/css/app-theme.css` (shadcn zinc defaults)

## Tooling

| Tool | Command |
|------|---------|
| PHP style | `composer lint` / `composer format` |
| Static analysis | `composer analyse` |
| Frontend lint | `npm run lint` |
| Tests | `php artisan test` |
MD

cat > "${TEMPLATE}/README.md" <<'MD'
# Web App (org template)

Generic Laravel + Inertia + Vue 3 scaffold for new monjizeen-dev products.

## Stack

- Laravel 13 + Inertia + Vue 3
- Tailwind CSS v4
- shadcn-vue (Reka UI) + Lucide icons
- Google OAuth

## Local setup

```bash
composer install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate
npm install && npm run build
php artisan serve
```

Set `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` in `.env` for OAuth.

## Design system

UI primitives live under `resources/js/components/ui/`. Add more via shadcn-vue CLI.
Use `lucide-vue-next` for all icons.
MD

echo "build: patch package.json design deps"
node -e "
const fs = require('fs');
const path = '${TEMPLATE}/package.json';
const pkg = JSON.parse(fs.readFileSync(path, 'utf8'));
pkg.name = 'web-app-template';
pkg.description = 'monjizeen-dev web app template';
const deps = {
  'class-variance-authority': '^0.7.1',
  'clsx': '^2.1.1',
  'lucide-vue-next': '^0.575.0',
  'reka-ui': '^2.8.2',
  'tailwind-merge': '^3.5.0',
  'tw-animate-css': '^1.4.0',
};
pkg.dependencies = { ...pkg.dependencies, ...deps };
fs.writeFileSync(path, JSON.stringify(pkg, null, 4) + '\n');
"

echo "build: patch vite for app-theme.css"
node -e "
const fs = require('fs');
const path = '${TEMPLATE}/vite.config.js';
let s = fs.readFileSync(path, 'utf8');
if (!s.includes('app-theme.css')) {
  s = s.replace(
    \"input: ['resources/css/app.css', 'resources/js/app.js']\",
    \"input: ['resources/css/app.css', 'resources/css/app-theme.css', 'resources/js/app.js']\"
  );
  fs.writeFileSync(path, s);
}
"

echo "build: patch app.css"
cat > "${TEMPLATE}/resources/css/app.css" <<'CSS'
@import './app-theme.css';
@import 'tailwindcss';

@source '../../vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php';
@source '../../storage/framework/views/*.php';
@source '../**/*.blade.php';
@source '../**/*.js';
@source '../**/*.vue';

@theme {
    --font-sans: ui-sans-serif, system-ui, sans-serif;
}
CSS

echo "build: done → ${TEMPLATE}"
