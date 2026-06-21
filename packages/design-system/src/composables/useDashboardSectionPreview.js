import { computed, reactive, ref, unref } from 'vue'

export const DASHBOARD_SECTION_LIMIT = 5
export const DASHBOARD_SECTION_EXPAND_LIMIT = 5

/**
 * Preview dashboard rows with optional expand/collapse (tables) or a compact more list (cards).
 *
 * @param {import('vue').MaybeRefOrGetter<Array<unknown>>} itemsSource
 * @param {{ limit?: number, expandable?: boolean }} [options]
 */
export function useDashboardSectionPreview(itemsSource, options = {}) {
  const limit = options.limit ?? DASHBOARD_SECTION_LIMIT
  const expandable = options.expandable ?? false
  const expanded = ref(false)

  const items = computed(() => {
    const source = typeof itemsSource === 'function' ? itemsSource() : unref(itemsSource)
    return Array.isArray(source) ? source : []
  })

  const totalCount = computed(() => items.value.length)
  const hasMore = computed(() => totalCount.value > limit)
  const hiddenCount = computed(() => Math.max(0, totalCount.value - limit))
  const visibleItems = computed(() => {
    if (expandable && (expanded.value || !hasMore.value)) {
      return items.value
    }

    return items.value.slice(0, limit)
  })
  const moreItems = computed(() => (expandable ? [] : items.value.slice(limit)))

  function showMore() {
    expanded.value = true
  }

  function showLess() {
    expanded.value = false
  }

  return reactive({
    expanded,
    hasMore,
    hiddenCount,
    visibleItems,
    moreItems,
    showMore,
    showLess,
  })
}
