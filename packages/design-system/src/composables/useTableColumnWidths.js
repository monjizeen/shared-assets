import { ref, computed, onMounted, toValue } from 'vue'

function clamp(n, min, max) {
  return Math.min(max, Math.max(min, Math.round(n)))
}

/** Upper bound for the sum of persisted column widths so the table stays within the viewport. */
function defaultMaxTableWidthPx() {
  if (typeof document === 'undefined') return 4096
  const w = document.documentElement.clientWidth
  return Math.max(320, w - 48)
}

/**
 * Persisted pixel widths for admin list tables (`<colgroup>` + `table-fixed`).
 *
 * @param {string} storageKey - localStorage key (unique per table)
 * @param {Record<string, { default: number, min?: number, max?: number }>} meta - known columns
 * @param {{ enabled?: boolean, maxTableWidthPx?: () => number, colgroupKeys?: object }} [options] - set `enabled: false` to disable load/save (e.g. tests); optional `maxTableWidthPx` caps total width during resize (defaults to viewport minus padding). Pass `colgroupKeys` (ref, computed, getter, or string array) in the same order as `<col v-for="k in colgroupKeys">` for resizable columns only. The first key uses `min-width` only so that column absorbs extra horizontal space in `table-fixed` layouts.
 */
export function useTableColumnWidths(storageKey, meta, options = {}) {
  const enabled = options.enabled !== false
  const maxTableWidthPx = typeof options.maxTableWidthPx === 'function' ? options.maxTableWidthPx : defaultMaxTableWidthPx
  const keys = Object.keys(meta)
  const stored = ref({})

  function resolveStretchColumnKey() {
    if (options.colgroupKeys == null) return null
    const list = toValue(options.colgroupKeys)
    if (!Array.isArray(list) || list.length === 0) return null
    const first = list[0]
    return first != null && meta[first] ? first : null
  }

  function clampKey(key, n) {
    const m = meta[key]
    if (!m) return n
    const min = m.min ?? 80
    const max = m.max ?? 720
    return clamp(n, min, max)
  }

  function load() {
    if (!enabled || typeof localStorage === 'undefined') return
    try {
      const raw = localStorage.getItem(storageKey)
      if (raw == null || raw === '') return
      const parsed = JSON.parse(raw)
      if (typeof parsed !== 'object' || parsed === null) return
      const next = {}
      for (const k of keys) {
        if (!Object.prototype.hasOwnProperty.call(parsed, k)) continue
        const n = Number(parsed[k])
        if (Number.isFinite(n)) next[k] = clampKey(k, n)
      }
      stored.value = next
    } catch {
      /* ignore corrupt storage */
    }
  }

  function persist() {
    if (!enabled || typeof localStorage === 'undefined') return
    try {
      const out = {}
      for (const k of keys) {
        const v = stored.value[k]
        if (v != null && Number.isFinite(v) && v !== meta[k].default) {
          out[k] = v
        }
      }
      const encoded = JSON.stringify(out)
      if (encoded === '{}') localStorage.removeItem(storageKey)
      else localStorage.setItem(storageKey, encoded)
    } catch {
      /* quota / private mode */
    }
  }

  const effectiveWidths = computed(() => {
    const out = {}
    for (const k of keys) {
      out[k] = stored.value[k] ?? meta[k].default
    }
    return out
  })

  function colStyle(key) {
    const w = effectiveWidths.value[key]
    if (w == null) return {}
    const stretchKey = resolveStretchColumnKey()
    if (stretchKey === key) {
      return { minWidth: `${w}px` }
    }
    return { width: `${w}px` }
  }

  const widthsAreDefault = computed(() => {
    for (const k of keys) {
      const v = stored.value[k]
      if (v != null && Number.isFinite(v) && v !== meta[k].default) return false
    }
    return true
  })

  /**
   * @param {string} columnKey
   * @param {PointerEvent} event
   */
  function beginResize(columnKey, event) {
    if (!enabled || !meta[columnKey]) return
    if (event.button !== 0) return
    event.stopPropagation()
    event.preventDefault()

    const el = event.currentTarget
    if (!(el instanceof Element)) return

    if (typeof el.setPointerCapture === 'function') {
      try {
        el.setPointerCapture(event.pointerId)
      } catch {
        /* ignore */
      }
    }

    const startX = event.clientX
    const w0 = effectiveWidths.value[columnKey]
    const rtl = typeof document !== 'undefined' && document.documentElement.getAttribute('dir') === 'rtl'

    function onMove(ev) {
      const dx = rtl ? startX - ev.clientX : ev.clientX - startX
      const raw = w0 + dx
      const m = meta[columnKey]
      const minW = m.min ?? 80
      const staticMax = m.max ?? 720

      let othersSum = 0
      for (const k of keys) {
        if (k === columnKey) continue
        othersSum += stored.value[k] ?? meta[k].default
      }
      const viewportCap = Math.max(minW, maxTableWidthPx() - othersSum)
      const next = clamp(raw, minW, Math.min(staticMax, viewportCap))
      stored.value = { ...stored.value, [columnKey]: next }
    }

    function onUp(ev) {
      if (typeof el.releasePointerCapture === 'function') {
        try {
          el.releasePointerCapture(ev.pointerId)
        } catch {
          /* ignore */
        }
      }
      document.removeEventListener('pointermove', onMove)
      document.removeEventListener('pointerup', onUp)
      document.removeEventListener('pointercancel', onUp)
      persist()
    }

    document.addEventListener('pointermove', onMove)
    document.addEventListener('pointerup', onUp)
    document.addEventListener('pointercancel', onUp)
  }

  function resetWidths() {
    stored.value = {}
    persist()
  }

  onMounted(() => {
    load()
  })

  return {
    effectiveWidths,
    colStyle,
    beginResize,
    resetWidths,
    widthsAreDefault,
  }
}
