# Web app template

Org scaffold for `/init-project` — **not** kawader.

## Stack

- Laravel 13 + Inertia + Vue 3 + Vite
- Tailwind CSS v4
- **shadcn-vue** (Reka UI) + **Lucide** (`lucide-vue-next`)
- Google OAuth shell (home, login, dashboard)

## Usage

```bash
shared-assets/scripts/init-project/scaffold-web.sh my-app
```

## Rebuild (maintainers)

Regenerates this folder from kawader OAuth shell (domain code stripped) + monjizeen UI primitives:

```bash
shared-assets/scripts/init-project/build-web-app-template.sh
```

Commit the result when the template changes.
