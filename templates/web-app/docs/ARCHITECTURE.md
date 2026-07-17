# Web App Architecture

Generic monjizeen web product scaffold.

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
