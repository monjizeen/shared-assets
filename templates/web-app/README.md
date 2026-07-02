# Web app template

Org scaffold for `/init-project` — **not** kawader.

Depends on **`@monjizeen/design-system`** (`../../packages/design-system`). Legacy UI files under `resources/js/components/ui/` are duplicated for offline template builds; prefer the package in new apps.

## Stack

- Laravel 13 + Inertia + Vue 3 + Vite
- Tailwind CSS v4
- **@monjizeen/design-system** (shadcn-vue primitives + org tokens)
- **Lucide** (`lucide-vue-next`)
- Google OAuth shell (home, login, dashboard)

## Usage

```bash
shared-assets/scripts/init-project/scaffold-web.sh my-app ~/Documents/work/monjizeen-dev closed
```

Third arg controls auth shell behavior: `closed` redirects guests from `/` to `/login`; `open` keeps the public home page. Scaffold installs org Cursor rules (`org-*.mdc`) and seeds `BRIEF.md` from the design-system template.

## Agent: new pages

1. `packages/design-system/docs/NEW-PAGE.md`
2. `packages/design-system/gallery/index.html` (visual reference)
3. Pattern slugs: `packages/design-system/docs/INDEX.md`

## Rebuild (maintainers)

Regenerates this folder from kawader OAuth shell (domain code stripped) + monjizeen UI primitives:

```bash
shared-assets/scripts/init-project/build-web-app-template.sh
```

Commit the result when the template changes.
