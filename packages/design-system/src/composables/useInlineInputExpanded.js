import { nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'

export function useInlineInputExpanded(controlWrapRef, watchSource) {
  const expanded = ref(false)
  let resizeObserver = null
  let mirrorEl = null
  let measureRaf = 0

  function controlElement() {
    const wrap = controlWrapRef.value
    if (!wrap) return null
    return (
      wrap.querySelector('[data-slot="input-group-control"]')
      ?? wrap.querySelector('textarea')
      ?? wrap.querySelector('input')
    )
  }

  function inputGroupElement() {
    return controlWrapRef.value?.closest('[data-slot="input-group"]') ?? null
  }

  function ensureMirror() {
    if (mirrorEl) return mirrorEl
    mirrorEl = document.createElement('textarea')
    mirrorEl.setAttribute('aria-hidden', 'true')
    mirrorEl.tabIndex = -1
    Object.assign(mirrorEl.style, {
      position: 'fixed',
      top: '0',
      left: '0',
      visibility: 'hidden',
      pointerEvents: 'none',
      overflow: 'hidden',
      border: '0',
      resize: 'none',
      margin: '0',
      height: 'auto',
    })
    document.body.appendChild(mirrorEl)
    return mirrorEl
  }

  function singleLineHeight(el) {
    const style = window.getComputedStyle(el)
    const lineHeight = Number.parseFloat(style.lineHeight)
    const paddingTop = Number.parseFloat(style.paddingTop)
    const paddingBottom = Number.parseFloat(style.paddingBottom)
    return lineHeight + paddingTop + paddingBottom
  }

  function copyTextareaMetrics(source, target) {
    const style = window.getComputedStyle(source)
    target.style.font = style.font
    target.style.fontSize = style.fontSize
    target.style.fontFamily = style.fontFamily
    target.style.fontWeight = style.fontWeight
    target.style.lineHeight = style.lineHeight
    target.style.letterSpacing = style.letterSpacing
    target.style.padding = style.padding
    target.style.boxSizing = style.boxSizing
    target.style.wordBreak = style.wordBreak
    target.style.overflowWrap = style.overflowWrap
    target.style.whiteSpace = style.whiteSpace
  }

  function inlineTextWidth(group) {
    const groupStyle = window.getComputedStyle(group)
    const padX = Number.parseFloat(groupStyle.paddingLeft) + Number.parseFloat(groupStyle.paddingRight)
    const gap = Number.parseFloat(groupStyle.columnGap || groupStyle.gap) || 0

    const start = group.querySelector('[data-slot="input-group-start"]')
    const end = group.querySelector('[data-slot="input-group-end"]')

    let reserved = padX
    if (start) reserved += start.offsetWidth + gap
    if (end) reserved += end.offsetWidth + gap

    return Math.max(0, group.clientWidth - reserved)
  }

  function needsExpandedLayout(el, group) {
    const mirror = ensureMirror()
    copyTextareaMetrics(el, mirror)
    mirror.style.width = `${inlineTextWidth(group)}px`
    mirror.value = el.value

    const threshold = singleLineHeight(el)
    return mirror.scrollHeight > threshold + 1
  }

  function measure() {
    const el = controlElement()
    const group = inputGroupElement()
    if (!el || !group) {
      expanded.value = false
      return
    }

    if (!el.value.trim()) {
      expanded.value = false
      return
    }

    expanded.value = needsExpandedLayout(el, group)
  }

  function scheduleMeasure() {
    cancelAnimationFrame(measureRaf)
    measureRaf = requestAnimationFrame(() => {
      measureRaf = 0
      measure()
    })
  }

  function bindObserver() {
    resizeObserver?.disconnect()
    const group = inputGroupElement()
    if (!group) return
    resizeObserver = new ResizeObserver(() => scheduleMeasure())
    resizeObserver.observe(group)
    scheduleMeasure()
  }

  onMounted(() => {
    nextTick(() => bindObserver())
  })

  onBeforeUnmount(() => {
    cancelAnimationFrame(measureRaf)
    resizeObserver?.disconnect()
    mirrorEl?.remove()
    mirrorEl = null
  })

  if (watchSource) {
    watch(watchSource, () => {
      nextTick(scheduleMeasure)
    })
  }

  return { expanded, measure, scheduleMeasure }
}
