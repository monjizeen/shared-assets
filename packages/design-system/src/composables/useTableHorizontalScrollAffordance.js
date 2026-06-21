import { ref, computed, onMounted, nextTick } from 'vue'
import { useResizeObserver, useEventListener } from '@vueuse/core'

/**
 * Tracks horizontal overflow on a scroll container and exposes thumb metrics for a
 * custom always-visible scrollbar (macOS overlay hides native bars until scroll).
 *
 * @param {import('vue').Ref<HTMLElement | null>} scrollRef
 * @param {import('vue').Ref<HTMLElement | null>} contentRef - e.g. `<table>`; ResizeObserver catches scrollWidth changes the scroll root alone may miss.
 */
export function useTableHorizontalScrollAffordance(scrollRef, contentRef) {
  const hasOverflow = ref(false)
  const thumbWidthPct = ref(100)
  const thumbInsetPct = ref(0)

  const thumbStyle = computed(() => ({
    width: `${thumbWidthPct.value}%`,
    insetInlineStart: `${thumbInsetPct.value}%`,
  }))

  function measure() {
    const el = scrollRef.value
    if (!el) return

    const { scrollWidth, clientWidth, scrollLeft } = el
    const maxScroll = scrollWidth - clientWidth
    if (maxScroll <= 0.5) {
      hasOverflow.value = false
      return
    }

    hasOverflow.value = true
    thumbWidthPct.value = (clientWidth / scrollWidth) * 100

    const dir = getComputedStyle(el).direction
    const travelled = dir === 'rtl' ? -scrollLeft : scrollLeft
    const p = Math.min(1, Math.max(0, travelled / maxScroll))
    thumbInsetPct.value = p * (100 - thumbWidthPct.value)
  }

  /**
   * @param {HTMLElement} trackEl
   * @param {number} clientX
   */
  function pointerScrollTo(trackEl, clientX) {
    const el = scrollRef.value
    if (!el || !trackEl) return

    const maxScroll = el.scrollWidth - el.clientWidth
    if (maxScroll <= 0) return

    const rect = trackEl.getBoundingClientRect()
    const dir = getComputedStyle(el).direction
    const ratio =
      dir === 'rtl'
        ? (rect.right - clientX) / rect.width
        : (clientX - rect.left) / rect.width
    const clamped = Math.min(1, Math.max(0, ratio))
    const targetLeft = dir === 'rtl' ? -clamped * maxScroll : clamped * maxScroll
    const allowSmooth =
      typeof window !== 'undefined' &&
      !window.matchMedia('(prefers-reduced-motion: reduce)').matches

    el.scrollTo({
      left: targetLeft,
      behavior: allowSmooth ? 'smooth' : 'auto',
    })
  }

  onMounted(() => {
    nextTick(() => {
      measure()
    })
  })

  useResizeObserver(scrollRef, () => {
    measure()
  })
  useResizeObserver(contentRef, () => {
    measure()
  })
  useEventListener(scrollRef, 'scroll', measure, { passive: true })
  useEventListener(window, 'resize', measure, { passive: true })

  return { hasOverflow, thumbStyle, measure, pointerScrollTo }
}
