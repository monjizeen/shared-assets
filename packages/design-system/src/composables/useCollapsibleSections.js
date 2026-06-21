import { onMounted, ref } from 'vue'

/**
 * Persist which list sections are collapsed (default: all expanded).
 *
 * @param {string} storageKey localStorage key
 */
export function useCollapsibleSections(storageKey) {
  const collapsedKeys = ref([])

  function loadState() {
    try {
      const raw = localStorage.getItem(storageKey)
      if (!raw) return
      const parsed = JSON.parse(raw)
      if (Array.isArray(parsed)) {
        collapsedKeys.value = parsed.filter((key) => typeof key === 'string')
      }
    } catch {
      /* ignore */
    }
  }

  function saveState() {
    try {
      localStorage.setItem(storageKey, JSON.stringify(collapsedKeys.value))
    } catch {
      /* ignore */
    }
  }

  function isExpanded(sectionKey) {
    return !collapsedKeys.value.includes(String(sectionKey))
  }

  function toggle(sectionKey) {
    const key = String(sectionKey)
    if (collapsedKeys.value.includes(key)) {
      collapsedKeys.value = collapsedKeys.value.filter((entry) => entry !== key)
    } else {
      collapsedKeys.value = [...collapsedKeys.value, key]
    }
    saveState()
  }

  onMounted(loadState)

  return { isExpanded, toggle }
}
