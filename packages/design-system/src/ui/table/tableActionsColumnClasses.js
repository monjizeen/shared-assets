/** Narrow icon-only actions column (<th> / <td>) when the table uses min-w-full. */
export const tableActionsColClass = 'w-px whitespace-nowrap'

/**
 * Marker class: `resources/css/app.css` removes the previous cell’s inline-end border so the
 * actions column blends with the column before it (works in LTR and RTL).
 */
export const tableActionsColMarkerClass = 'table-actions-col'

/**
 * Ghost actions header: no visible label (use `<span class="sr-only">` in markup).
 * Keeps horizontal row borders; no vertical seam with the previous column (see marker + app.css).
 */
export const tableActionsThGhostClass = [
  tableActionsColMarkerClass,
  'border-b border-border/50 border-s-0 bg-transparent px-2 py-2 text-end align-middle text-[11px] font-normal text-muted-foreground tracking-wide',
].join(' ')

/**
 * Ghost actions body/footer cell: horizontal borders only; blends with previous column.
 */
export const tableActionsTdGhostClass = [
  tableActionsColMarkerClass,
  'border-b border-border/50 border-s-0 px-2 py-1.5 text-end align-middle',
].join(' ')

const tableActionsToolbarLayout = 'inline-flex w-fit items-center justify-end gap-1'

/**
 * Row actions are always visible.
 */
export const tableActionsToolbarClass = tableActionsToolbarLayout

/** Same layout as row actions, always visible (e.g. inline “add row” submit control). */
export const tableActionsToolbarStaticClass = tableActionsToolbarLayout
