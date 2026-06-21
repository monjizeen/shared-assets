# Design patterns — quick index

Org UI patterns distilled from **monjizeen** (reference implementation). Use these slugs when scoping work: *"use `bottom-nav`"*, *"use `inline-create`"*, etc.

**Canonical source:** `@monjizeen/design-system` (`shared-assets/packages/design-system`)  
**Reference app:** `monjizeen` — domain-specific shells (nav config, entity cards) stay in-app  
**Full catalog:** [PATTERNS.md](./PATTERNS.md)

Stack: Laravel + Inertia + Vue 3 + shadcn-vue (Reka UI) + Lucide + Tailwind v4.

---

## Pattern chooser

| When you need… | Use slug | Primary components |
|----------------|----------|-------------------|
| Authenticated app shell | `app-layout` | `AppLayout` |
| Mobile tab navigation (fixed bottom) | `bottom-nav` | `BottomNav` + `bottomNav.js` |
| Desktop top navigation | `primary-nav` | `PrimaryNav` + `primaryNav.js` |
| Mobile overflow menu (slide-in) | `nav-drawer` | `PrimaryNavMobile` + `NavDrawerContent` |
| Keyboard-safe fixed bottom UI | `keyboard-bottom-offset` | `useVisualViewportKeyboard` |
| Admin table list + header filters | `admin-index-table` | `TableWrapper`, filter `DropdownMenu` |
| Index page, create-at-bottom is primary | `input-action-index` | `InputActionIndexPageLayout` + `SimpleInlineCreateInput` |
| Pill-shaped inline create bar | `inline-create` | `InlineInputGroup` + create wrappers |
| Multi-field inline create (segments) | `list-inline-create` | `ListInlineCreateInput` |
| Full-height scrollable entity list | `full-height-list` | `ListIndexView` or `PileIndexView` |
| Standard detail page | `detail-page` | `AppLayout` → `space-y-6` |
| List row with leading/actions/mobile overflow | `master-card` | `MasterCard` + `CardMobileMoreMenu` |
| Ticket-style row with inline pickers | `ticket-card` | `TicketCard` |
| Empty list or dashboard section | `empty-state` | `EmptyStatePanel` |
| Collapsible week/org groups | `collapsible-section` | `ListCollapsibleSection` |
| Horizontal mode / entity switcher | `segmented-tabs` | Pill `role="tablist"` (see design.mdc) |
| Filter + sort icon toolbar | `filter-dropdown-toolbar` | Ghost icon `DropdownMenu` + optional dot |
| Modal CRUD | `form-dialog` | `Dialog` + `useFormDialog` |
| Label + field (+ floating label) | `form-field` | `FormField` |
| Rich text (markdown) | `rich-text-editor` | `RichTextEditor` |
| Toast notifications | `toast` | `Toast` + `useToast` |
| Light/dark with canvas transition | `theme-transition` | `ThemeTransitionAppShell` |
| Breadcrumb on detail pages | `page-breadcrumb` | `PageBreadcrumb` |
| Expandable toolbar search | `expandable-search` | Collapsible search in list toolbars |
| Dense admin filter panel | `admin-filter-panel` | `AdminFilterDropdownPanel` |
| Onboarding wizard | `onboarding-layout` | `OrgOwnerOnboardingLayout` |

---

## Aliases (spoken name → slug)

| You might say | Slug |
|---------------|------|
| bottom bar / bottom navigation | `bottom-nav` |
| inline input / pill input / sticky create | `inline-create` |
| drawer / hamburger menu | `nav-drawer` |
| sheet | *(not used — use `nav-drawer` or `form-dialog`)* |
| quick actions list | `full-height-list` + `list-inline-create` |
| global labels page style | `input-action-index` |
| projects admin table style | `admin-index-table` |

---

## Page-type decision tree

```
New authenticated page?
├─ Detail / settings / form-heavy → detail-page (space-y-6)
├─ Admin sortable table, add via header button → admin-index-table
├─ Index where bottom create is the hero → input-action-index + inline-create
├─ Entity feed (tickets, pile, quick actions) → full-height-list
└─ Onboarding steps → onboarding-layout
```

---

## Copy-from references (monjizeen)

| Pattern | Start from |
|---------|------------|
| `input-action-index` | `Pages/admin/GlobalLabelsIndexPage.vue` |
| `admin-index-table` | `Pages/admin/QuickActionsPage.vue` |
| `full-height-list` | `components/lists/ListIndexView.vue` |
| `form-dialog` | `ProjectFormDialog.vue` + `lib/useFormDialog.js` |
| `segmented-tabs` | `TicketDetailPage.vue` activity tabs |
| `detail-page` | `ProfilePage.vue` |

---

## Adoption in new projects

1. Scaffold via `init-project` (web template has shadcn primitives only).
2. Add shadcn components as needed (`dialog`, `table`, `dropdown-menu`, `combobox`, …).
3. **Port app-level patterns** from monjizeen when the product needs them — they are not in the web template yet.
4. Follow tokens in `@monjizeen/design-system/styles` and rules in `monjizeen/.cursor/rules/design.mdc`

See [PATTERNS.md](./PATTERNS.md) for props, slots, and implementation notes per pattern.
