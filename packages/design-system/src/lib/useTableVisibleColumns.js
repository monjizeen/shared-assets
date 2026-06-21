import { ref, computed, watch, onMounted } from 'vue'

function buildAllVisible(keys) {
  return Object.fromEntries(keys.map((k) => [k, true]))
}

function mergeSavedWithDefaults(parsed, keys) {
  const merged = {}
  for (const k of keys) {
    merged[k] =
      parsed != null && Object.prototype.hasOwnProperty.call(parsed, k)
        ? Boolean(parsed[k])
        : true
  }
  return merged
}

function columnsEqual(a, b, keys) {
  for (const k of keys) {
    if (Boolean(a[k]) !== Boolean(b[k])) return false
  }
  return true
}

/**
 * Table column visibility with localStorage persistence.
 * Defaults: every known column is visible; saved state is merged so new columns stay visible.
 *
 * @param {string} storageKey - unique key per table (e.g. `monjizeen:admin:projects-columns`)
 * @param {string[] | Record<string, boolean>} columnKeys - column ids; array order defines keys, or object keys only (values ignored)
 * @param {{ enabled?: boolean }} [options]
 */
export function useTableVisibleColumns(storageKey, columnKeys, options = {}) {
  const keys = Array.isArray(columnKeys) ? columnKeys : Object.keys(columnKeys)
  const defaultColumns = buildAllVisible(keys)
  const visibleColumns = ref({ ...defaultColumns })
  const customizationEnabled = options.enabled !== false

  function load() {
    if (!customizationEnabled || typeof localStorage === 'undefined') return
    try {
      const raw = localStorage.getItem(storageKey)
      if (raw == null || raw === '') return
      const parsed = JSON.parse(raw)
      if (typeof parsed !== 'object' || parsed === null) return
      visibleColumns.value = mergeSavedWithDefaults(parsed, keys)
    } catch {
      /* ignore corrupt storage */
    }
  }

  function save() {
    if (!customizationEnabled || typeof localStorage === 'undefined') return
    try {
      localStorage.setItem(storageKey, JSON.stringify(visibleColumns.value))
    } catch {
      /* quota / private mode */
    }
  }

  onMounted(() => {
    if (!customizationEnabled) {
      visibleColumns.value = { ...defaultColumns }
      return
    }
    load()
  })

  watch(visibleColumns, () => {
    if (!customizationEnabled) return
    save()
  }, { deep: true })

  const columnsAreDefault = computed(() =>
    columnsEqual(visibleColumns.value, defaultColumns, keys),
  )

  function resetColumns() {
    if (!customizationEnabled) return
    visibleColumns.value = { ...defaultColumns }
  }

  return {
    visibleColumns,
    defaultColumns,
    columnsAreDefault,
    resetColumns,
  }
}
