# Design patterns — full catalog

Distilled from the **monjizeen** reference app. Each pattern has a **slug** (use in specs and agent prompts), **when to use**, **building blocks**, and **monjizeen paths** for copy/port.

Primitives live in `@monjizeen/design-system/src/ui/` (shadcn-vue). App patterns live in `src/patterns/`, `composables/`, `lib/`.

---

## Foundations

### `design-tokens`

**When:** Any UI work in a monjizeen-dev web app.

**Rules:**
- Semantic Tailwind tokens only — no raw hex (`bg-primary`, `text-muted-foreground`, …).
- Logical CSS for RTL: `ps-*`, `pe-*`, `text-start`, never `pl-*` / `text-left`.
- Typography: body font below `text-xl`; heading font at `text-xl` and up (locale-specific stacks in `app-theme.css`).
- `data-slot` attributes for CSS targeting, not ad-hoc class hooks on primitives.
- Interactive press: global scale on `:active` (`--mo-press-*` in `app-theme.css`); opt out with `no-interactive-press`.

**Source:** `monjizeen/.cursor/rules/design.mdc`, `resources/css/app-theme.css`

---

## Layout shells

### `app-layout`

**When:** Every authenticated Inertia page.

**What:** Sticky header, `max-w-[960px]` main column, toast host, bottom-nav padding (`app-has-bottom-nav`), theme transition shell.

**Key API:** Wraps page content; padding on `<main>` — pages must not add `p-6` or extra `max-w-*`.

**Paths:** `resources/js/layouts/AppLayout.vue`

**Related:** `bottom-nav`, `theme-transition`, `keyboard-bottom-offset`

---

### `input-action-index`

**When:** Index pages where **sticky bottom inline create** is the primary action (e.g. global labels, packages).

**What:** Full-height column, centered empty state, sticky pill footer above bottom nav.

**Components:** `InputActionIndexPageLayout`
- Props: `title`, `titleClass`
- Slots: `title`, `actions`, default (body), `footer`
- Expose: `scrollToFooterWithHighlight()`, `focusFooterInput()`

**Footer:** `SimpleInlineCreateInput` (or `ListInlineCreateInput` for multi-field segments).

**Paths:** `components/InputActionIndexPageLayout.vue`, `Pages/admin/GlobalLabelsIndexPage.vue`, `PackagesIndexPage.vue`

**Related:** `inline-create`, `empty-state`, `bottom-nav`

---

### `admin-index-table`

**When:** Admin index pages that are primarily a **sortable/filterable table** with add via header button.

**What:**
- `AppLayout` → `space-y-6`
- Header: title `text-4xl font-semibold` + toolbar (`ButtonGroup`, ghost filter icon, `+` add)
- Filters in **dropdown**, not a filter card above the table
- Dense `TableWrapper` with shared action column classes

**Paths:** `design.mdc` (Admin index list pages), `Pages/admin/QuickActionsPage.vue`

**Related:** `admin-filter-panel`, `filter-dropdown-toolbar`

---

### `full-height-list`

**When:** Entity feeds that fill the viewport — tickets, pile, quick actions.

**What:** `flex min-h-0 flex-1 flex-col` root; toolbar + scrollable list + optional inline create footer.

**Components:** `ListIndexView`, `PileIndexView`

**Paths:** `components/lists/ListIndexView.vue`, `components/pile/PileIndexView.vue`

**Related:** `list-inline-create`, `filter-dropdown-toolbar`, `master-card`

---

### `detail-page`

**When:** Single-entity detail, profile, settings.

**What:** `AppLayout` → `<div class="space-y-6">` — no shared wrapper component.

**Optional:** `PageBreadcrumb`, `segmented-tabs` for sub-views.

**Paths:** `ProfilePage.vue`, `TicketDetailPage.vue`, `frontend-conventions.mdc`

---

### `onboarding-layout`

**When:** Multi-step org/user onboarding.

**Components:** `OrgOwnerOnboardingLayout` — progress bar, bordered card, step labels.

**Paths:** `layouts/OrgOwnerOnboardingLayout.vue`

---

### `card-index-page` (legacy)

**When:** Avoid for new work. Legacy card-wrapped index + horizontal footer form.

**Components:** `CardIndexPageLayout`, `CardIndexPageFooterForm`

**Prefer:** `input-action-index`

---

## Navigation & mobile

### `bottom-nav`

**When:** Primary mobile navigation — fixed tab bar.

**Note:** Not named "BottomBar" in code.

**Components:** `BottomNav` (`data-slot="bottom-nav"`, `lg:hidden`)
- Prop: `layoutBottomOffset` — shifts nav when keyboard opens

**Config:** `resources/js/config/bottomNav.js`

**Paths:** `components/navigation/BottomNav.vue`

**Related:** `keyboard-bottom-offset`, `app-layout`

---

### `primary-nav`

**When:** Desktop horizontal nav links.

**Components:** `PrimaryNav`, `usePrimaryNav`, `config/primaryNav.js`

---

### `nav-drawer`

**When:** Mobile hamburger → full-height slide-in panel.

**Note:** Uses **Dialog**, not a Sheet primitive.

**Components:** `PrimaryNavMobile`, `NavDrawerContent` (RTL-aware slide, `data-slot="nav-drawer-content"`)

**Paths:** `components/navigation/NavDrawerContent.vue`

---

### `keyboard-bottom-offset`

**When:** Any fixed bottom UI (bottom nav, sticky inline create) must clear the on-screen keyboard.

**Composable:** `useVisualViewportKeyboard()` → `layoutBottomOffset`, `keyboardOpen`

**CSS var:** `--layout-bottom-offset` on app shell

**Paths:** `composables/useVisualViewportKeyboard.js`, `InputActionIndexPageLayout.vue` (footer `bottom` calc)

---

### `page-breadcrumb`

**When:** Detail pages with navigable hierarchy.

**API:** `items: { label, href? }[]`

**Paths:** `components/navigation/PageBreadcrumb.vue`

---

## Inline create system

### `inline-create`

**When:** Pill-shaped bottom or inline "create" bar with circular submit.

**Shell:** `InlineInputGroup` — `rounded-[24px]`, slots `start` / control / `end`
- Control must use `data-slot="input-group-control"`
- Auto-expands to two-row grid when text wraps (`useInlineInputExpanded`)

**Wrappers:**

| Component | Use case |
|-----------|----------|
| `SimpleInlineCreateInput` | Single-field create (admin index footers) |
| `ListInlineCreateInput` | Quick Actions multi-entity create (`segment` prop) |
| `PileInlineCreateInput` | Pile inbox create with project/priority pickers |

**SimpleInlineCreateInput props:** `modelValue`, `placeholder`, `disabled`, `busy`, `errorMessage`, `submitDisabled`, `submitAriaLabel`, `inputId`, `inputAriaLabel`  
**Emits:** `update:modelValue`, `submit`, `keydown`

**Submit affordance:** Circular green `ArrowUp` button inside the pill.

**Action overflow (> 3 field actions):** Keep 2 inline; rest in `MoreHorizontal` menu with `DropdownMenuSub` rows (chevron opens same panel as inline). Use `InlineInputActionsBar` + `InlineInputAction`. Submit never counts toward the limit. See `design.mdc` → Inline input action overflow.

**Paths:** `InlineInputGroup.vue`, `InlineInputActionsBar.vue`, `InlineInputAction.vue`, `SimpleInlineCreateInput.vue`, `lists/ListInlineCreateInput.vue`, `pile/PileInlineCreateInput.vue`

---

### `expandable-search`

**When:** Toolbar search should stay icon-only until expanded.

**What:** Collapsible search in `ListIndexView` / `PileIndexView` — `data-slot="qa-visible-search"` / `pile-visible-search`, click-outside to collapse.

---

## Cards & list rows

### `master-card`

**When:** Reusable list row: leading + content + desktop actions + mobile overflow.

**Slots:** `leading`, default, `actions`, `mobile-actions`  
**Prop:** `actionsClass`

**Container:** `MasterCardList` — bordered divided list.

**Paths:** `MasterCard.vue`, `MasterCardList.vue`

---

### `ticket-card`

**When:** Ticket row with inline status, assignee, labels, project pickers.

**Props:** `task`, `assignableUsers`, `workflowStatuses`, `projects`, labels, `updateRedirect`, `selectable`, `selected`, `variant: default | dashboard`

**Related:** `card-mobile-more-menu`, `creatable-combobox`

---

### `work-update-card` / `project-card` / `pile-card`

Domain-specific `MasterCard` variants. `PileCard` adds drag handle, inline title edit, complete action.

---

### `list-quick-row`

**When:** Generic quick-actions rows (orgs, users, work logs).

**Components:** `ListQuickRow`, `ListQuickRowIcon`, `ListQuickRowMeta`

---

### `card-mobile-more-menu`

**When:** Desktop shows inline actions; mobile collapses to `MoreHorizontal` menu.

**Props:** `useMenu` (false = render children directly), `disabled`, `contentClass`

---

## Toolbars, filters & tables

### `filter-dropdown-toolbar`

**When:** List pages need filters without an always-visible filter row.

**What:** Ghost icon `Button` + `Filter` icon; optional **primary dot** when filters active; panel stacks search + combobox facets + apply/reset.

**Sort variant:** Second ghost icon + `ArrowUpDown` when API supports `sort` + `dir`.

**Paths:** `ListIndexView.vue`, `PileIndexView.vue`, `TableFilterDropdownActions.vue`

---

### `admin-filter-panel`

**When:** Standard admin filter dropdown shell.

**Component:** `AdminFilterDropdownPanel` — titled "Filters", stacked slot, `align` prop.

---

### `segmented-tabs`

**When:** Horizontal `role="tablist"` mode switcher on same page.

**Classes:** `rounded-full border border-border/60 bg-muted/40 p-1` track; active segment `bg-card shadow-sm`; inactive `text-muted-foreground`.

**Rules:** Icon + label with `gap-1.5`; label intrinsic width (no `flex-1` on label span); stable `data-slot` for tests.

**Paths:** `design.mdc`, `TicketDetailPage.vue`, Quick Actions segment bar

---

### `button-group-toolbar`

**When:** Segmented icon button clusters in toolbars.

**Component:** `ui/button-group/ButtonGroup.vue`

---

### Table helpers

| Piece | Path |
|-------|------|
| `TableWrapper` + horizontal scroll affordance | `ui/table/TableWrapper.vue`, `useTableHorizontalScrollAffordance` |
| Sortable headers | `SortableTh.vue`, `useTableSort` |
| Resizable columns | `TableColumnResizeHandle.vue`, `useTableColumnWidths` |
| Action column classes | `tableActionsColClass`, etc. from `ui/table` |

---

## Modals & dialogs

### `form-dialog`

**When:** Modal create/edit CRUD.

**Stack:** shadcn `Dialog` + `useFormDialog` + `FormField`

**useFormDialog API:** `defaults()`, `populate(record)` → `{ open, editing, form, submitted, saving, openAdd, openEdit, close, submit }`

**Auto-focus:** `handleDialogOpenAutoFocus` on dialog open (`lib/focusFirstFormField.js`)

**Examples:** `ProjectFormDialog`, `WorkLogDialog`, `TicketDialog`

**Note:** No Sheet component — overlays are Dialog or non-modal DropdownMenu (`:modal="false"` on card inline pickers).

---

## Forms & inputs

### `form-field`

**When:** Label + control with optional floating label and error display.

**Props:** `label`, `required`, `error`, `htmlFor`, `floatLabel`  
**Slot:** scoped — `inputClass`, `errorClass`

---

### `validation-field-hint` / `inline-field-tooltip`

Compact error tooltip and info tooltip on inline controls.

---

### `rich-text-editor` / `markdown-view`

TipTap markdown editor (`RichTextEditor`) and read-only renderer (`MarkdownView`).

---

### `creatable-combobox`

Create-new option via `n:` + encoded name prefix. Used for ticket labels and projects.

**Variants:** `default | inline` for card vs dialog density.

---

### `phone-country-input`

Country code picker + dial code for user create flows.

---

### Initial focus

| Context | Mechanism |
|---------|-----------|
| Dialog opens | `handleDialogOpenAutoFocus` (automatic on `DialogContent`) |
| Inline / page form mounts | `useFocusFirstFormFieldOnMount(formRootRef)` |
| List page toolbars | Do **not** auto-focus filter controls |

---

## Empty & collapsible states

### `empty-state`

**When:** No data in list or dashboard section.

**Component:** `EmptyStatePanel`
- Props: `title`, `description`, `compact` (dashboard inset vs full-height index)
- Slots: `icon`, `action`

**Index pages:** not `compact`; optional CTA scrolls to footer create (`scrollToFooterWithHighlight`).

---

### `collapsible-section`

**When:** Grouped list sections (week groups, org groups, pile sections).

**Component:** `ListCollapsibleSection` + `useCollapsibleSections`  
**Props:** `sectionKey`, `title`, `expanded`, `count`

---

### `dashboard-section-preview`

Capped lists with "show more" on dashboard — `useDashboardSectionPreview`, `DASHBOARD_SECTION_EXPAND_LIMIT`.

---

## Feedback & theme

### `toast`

Fixed bottom-end notifications. Types: `error`, `success`, `warning`, `info`. `useToast()` API.

---

### `theme-transition`

`ThemeTransitionAppShell` fades UI during sunrise/sunset canvas transition. **Teleport to body** does not inherit fade — bind `theme.transitionActive` manually.

**Related:** `ThemeToggle`, `ThemeTransitionOverlay`, `store/theme.js`

---

### `locale-switcher`

EN ↔ AR toggle; `block` variant for full-width.

---

## shadcn primitives (starter set)

Import from `@/components/ui/{name}`:

| Primitive | Notes |
|-----------|-------|
| `button` | Custom variants: `ghostHeaderIcon`, `ghostSubtle`; sizes `xs`, `icon-sm` |
| `input`, `textarea` | RTL `text-start`; `data-slot` targeting |
| `card`, `label`, `separator`, `switch`, `avatar` | Standard shadcn-vue |
| `select`, `combobox`, `dropdown-menu` | Often `:modal="false"` in dense card rows |
| `dialog` | Modal + scroll content |
| `table` | + wrapper, sortable headers, action column helpers |
| `badge` | Status chips |
| `button-group` | Toolbar clusters |

**Web template ships:** Button, Card, Input, Label, Separator only. Add others via `npx shadcn-vue add …`.

---

## Domain composites (page-level)

These bundle multiple patterns — prefer extending over reimplementing.

| Slug | Component | Page entry |
|------|-----------|------------|
| `quick-actions-hub` | `ListIndexView` | `TicketsIndexPage.vue`, etc. |
| `pile-inbox` | `PileIndexView` | `PileIndexPage.vue` |
| `dashboard` | stat cards + preview lists + inline work log | `DashboardPage.vue` |
| `history-timeline` | typed activity feed | `HistoryTimeline.vue` |

---

## Maintaining this catalog

1. **Source of truth for code:** `@monjizeen/design-system` (`shared-assets/packages/design-system`)
2. **Source of truth for token/rules detail:** `monjizeen/.cursor/rules/design.mdc` (until ported to package docs)
3. **Source of truth for page structure:** `monjizeen/.cursor/rules/frontend-conventions.mdc`
4. When a pattern stabilizes, run `packages/design-system/scripts/sync-from-monjizeen.sh` and update this doc
