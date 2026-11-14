---
name: apply-asaas-skin
description: >
  Apply a presented app design (HTML/CSS, mocks, redesign) as a theme skin on Asaas.
  Always install @asaas/design-system first, analyze tokens/components, then paint via
  CSS variables + Tailwind — never invent a parallel UI kit. Use when Omar says present
  design, apply design, redesign, new skin/theme, or drops HTML/CSS look for a Vue app.
---

# Apply Asaas skin

Org skill for monjizeen-domain **Laravel + Inertia + Vue** apps.

**Contract:** `asaas/packages/design-system/docs/THEMES.md`  
**Steps detail:** `asaas/packages/design-system/docs/APPLY-SKIN.md`  
**Gallery:** https://enjaz.mnjz.in

## When to use

- Omar presents a new look (HTML/CSS files, static gallery, Figma notes, “redesign X”)
- “Apply this design to Monjizeen / Waqti / …”
- “Make this a theme/skin”

## Do not use

- Pure backend / API work
- Adding one missing shadcn primitive with no new product look (use Asaas agent only)
- Employer / `tier: job` domains

## Pipeline (mandatory order)

### Phase 0 — Scope

1. Confirm **target app repo** (ask if unclear).
2. Confirm design source paths (HTML/CSS/mocks).

### Phase 1 — Install Asaas

In the **target app**:

1. Add dependency if missing:
   - Mono: `"@asaas/design-system": "file:../asaas/packages/design-system"`
   - Or GitHub dep per Asaas README
2. `npm install`
3. Vite alias → package `src` (see Asaas README)
4. CSS: `@import '@asaas/design-system/styles';` **before** app skin; Tailwind `@source` includes package
5. Install AI rules:
   ```bash
   bash ../asaas/packages/design-system/scripts/install-cursor-rules.sh "$(pwd)"
   ```
6. Prove import works (dev build or smoke page). **Do not paint until this passes.**

### Phase 2 — Analyze design

From the presented HTML/CSS:

| Extract | Map to |
|---------|--------|
| Brand colors | `--brand-green`, `--brand-navy`, `--brand-blue` + semantic `--primary`, `--background`, … |
| Fonts | `--font-heading*`, `--font-body*` |
| Radius / border / ring | `--radius`, `--border`, `--ring` |
| Light + dark | `:root` and `.dark` |
| UI pieces | Existing `@asaas/design-system/ui/*` + patterns |
| Missing pieces | List → implement in **asaas** first |

Output a short **skin brief** (tokens table + component map + gaps). Show Omar TLDR before big page ports if look is ambiguous.

### Phase 3 — Apply skin

1. Create/update app skin file (e.g. `resources/css/app-theme-skin.css`) implementing the Asaas token contract.
2. Import skin **after** Asaas styles in `app.css`.
3. Wire fonts (link or `@font-face`) per design.
4. Port screens using **Asaas components only** + Tailwind for layout/spacing/state.
5. Gaps: add primitive/pattern + gallery demo in `asaas`, then import in app.
6. Do **not** keep a second Button/Input system in the app.

### Phase 4 — Verify

- Light + dark
- RTL if app is bilingual
- One real page matches the mock intent (not pixel-perfect HTML dump)
- Checks green → commit + push (staging / playground). **Ship** = production only.

## Success criteria

- [ ] App depends on `@asaas/design-system`
- [ ] Skin is CSS variables on Asaas, not a new component library
- [ ] Pages import from `@asaas/design-system/...`
- [ ] Gaps landed in Asaas (if any)
- [ ] Omar can see look in the running app

## Related

- Asaas agent: package/gallery ownership
- App agent: page wiring in product repo
