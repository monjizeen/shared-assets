# @monjizeen/design-system

Org-wide design system for **Laravel + Inertia + Vue 3** apps. Single source of truth for UI primitives, patterns, tokens, and shared composables.

**Reference consumer:** `monjizeen` (patterns still being migrated to import from this package).

## Layout

```
packages/design-system/
├── docs/                 # Pattern catalog (INDEX.md, PATTERNS.md)
├── styles/
│   ├── brand.css         # Brand primitives (--brand-green, …)
│   ├── theme.css         # Semantic tokens, typography, dark mode, motion
│   ├── utilities.css     # Table scroll, bottom-nav offsets, inline edit
│   └── index.css         # Single entry — import this in apps
├── assets/fonts/         # Somar Sans (when synced from monjizeen)
├── src/
│   ├── ui/               # shadcn-vue primitives (button, dialog, table, …)
│   ├── patterns/
│   │   ├── navigation/   # PageBreadcrumb, NavDrawerContent
│   │   ├── layout/       # Index layouts, theme shell, Toast
│   │   ├── forms/        # FormField, inline create, tooltips
│   │   ├── lists/        # List rows, empty state, table helpers
│   │   └── admin/        # AdminFilterDropdownPanel
│   ├── composables/      # Table, keyboard, collapsible, avatar helpers
│   ├── lib/              # cn(), toast, focus, validation, theme canvas
│   └── store/            # theme (light/dark/system)
└── scripts/
    └── sync-from-monjizeen.sh   # Maintainer: pull latest from reference app
```

## Install (monjizeen-dev mono root)

In your app `package.json`:

```json
{
  "dependencies": {
    "@monjizeen/design-system": "file:../shared-assets/packages/design-system"
  }
}
```

From GitHub (outside mono root):

```json
"@monjizeen/design-system": "github:monjizeen-dev/shared-assets#main:packages/design-system"
```

Then `npm install`.

## Vite setup

```js
import path from 'node:path'
import { defineConfig } from 'vite'

export default defineConfig({
  resolve: {
    alias: {
      '@monjizeen/design-system': path.resolve(
        __dirname,
        'node_modules/@monjizeen/design-system/src',
      ),
    },
  },
})
```

**Tailwind v4** — scan package classes in `resources/css/app.css`:

```css
@import '@monjizeen/design-system/styles';
@import 'tailwindcss';

@source '../../node_modules/@monjizeen/design-system/src/**/*.{vue,js}';
@source '../**/*.{vue,js}';
```

## Usage

```js
// Primitives
import { Button } from '@monjizeen/design-system/ui/button'
import { Dialog, DialogContent } from '@monjizeen/design-system/ui/dialog'

// Patterns
import FormField from '@monjizeen/design-system/patterns/forms/FormField.vue'
import EmptyStatePanel from '@monjizeen/design-system/patterns/lists/EmptyStatePanel.vue'

// Utilities
import { cn } from '@monjizeen/design-system/lib/utils'
import { useToast } from '@monjizeen/design-system/lib/useToast'
import { theme } from '@monjizeen/design-system/store/theme'

// Styles (app entry or app.css)
import '@monjizeen/design-system/styles'
```

## Peer dependencies

Apps must provide: `vue`, `reka-ui`, `@vueuse/core`, `lucide-vue-next`, `class-variance-authority`, `clsx`, `tailwind-merge`, `tailwindcss`, `tw-animate-css`.

Optional: `@tanstack/vue-table` (table utils), `@inertiajs/vue3` + `vue-i18n` (PageBreadcrumb, filter panel).

## Maintainer workflow

When monjizeen DS changes stabilize:

```bash
cd packages/design-system
npm run sync
# Review diff, bump version in package.json, commit
```

Domain-specific UI (tickets, projects, app nav config) stays in app repos — not in this package.

## Docs

- [Pattern index](./docs/INDEX.md) — slug chooser
- [Full catalog](./docs/PATTERNS.md) — props, when-to-use, paths

## Versioning

Semver once consumers depend on published tags. During `0.x`, breaking changes may land with minor bumps — pin apps to tags/commits in production.
