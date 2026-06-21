import { ref } from 'vue'

/**
 * Composable for table column sort state.
 * @param {string|null} initialSortBy - Initial sort key (e.g. 'name')
 * @param {'asc'|'desc'} initialDir - Initial direction
 * @returns {{ sortBy: Ref, sortDir: Ref, toggleSort: (key: string) => void, sortDirection: (key: string) => 'asc'|'desc'|null }}
 */
export function useTableSort(initialSortBy = null, initialDir = 'asc') {
  const sortBy = ref(initialSortBy)
  const sortDir = ref(initialDir)

  function toggleSort(key) {
    if (sortBy.value === key) {
      sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
    } else {
      sortBy.value = key
      sortDir.value = 'asc'
    }
  }

  function sortDirection(key) {
    if (sortBy.value !== key) return null
    return sortDir.value
  }

  return { sortBy, sortDir, toggleSort, sortDirection }
}

/**
 * Sort an array by a key with optional getter map.
 * @param {Array} list - Array to sort (not mutated)
 * @param {string|null} key - Sort key (e.g. 'name')
 * @param {'asc'|'desc'} dir - Sort direction
 * @param {Record<string, (item: any) => any>} getters - Map of key -> getter(item). If key not in getters, item[key] is used.
 * @returns {Array} New sorted array
 */
export function sortByKey(list, key, dir, getters = {}) {
  if (!key || !list.length) return [...list]
  const getter = getters[key] ?? ((item) => item[key])
  const mult = dir === 'asc' ? 1 : -1
  return [...list].sort((a, b) => {
    const va = getter(a)
    const vb = getter(b)
    if (va == null && vb == null) return 0
    if (va == null) return mult
    if (vb == null) return -mult
    if (typeof va === 'string' && typeof vb === 'string') {
      return mult * va.localeCompare(vb, undefined, { numeric: true })
    }
    if (typeof va === 'number' && typeof vb === 'number') return mult * (va - vb)
    return mult * String(va).localeCompare(String(vb), undefined, { numeric: true })
  })
}
