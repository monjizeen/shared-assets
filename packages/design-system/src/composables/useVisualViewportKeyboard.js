import { onBeforeUnmount, onMounted, ref } from 'vue'

/** Minimum visual-viewport shrink (px) before treating the keyboard as open. */
const KEYBOARD_OPEN_THRESHOLD_PX = 80

/**
 * Track mobile virtual-keyboard open state via Visual Viewport API.
 * Returns layout-bottom offset so fixed bottom UI can stay on the page bottom
 * (behind the keyboard) instead of floating above it.
 */
export function useVisualViewportKeyboard() {
  const layoutBottomOffset = ref(0)
  const keyboardOpen = ref(false)

  function update() {
    const viewport = window.visualViewport
    if (!viewport) {
      layoutBottomOffset.value = 0
      keyboardOpen.value = false
      return
    }

    const offset = Math.max(
      0,
      window.innerHeight - viewport.height - viewport.offsetTop,
    )

    layoutBottomOffset.value = offset
    keyboardOpen.value = offset >= KEYBOARD_OPEN_THRESHOLD_PX
  }

  onMounted(() => {
    const viewport = window.visualViewport
    if (!viewport) return

    viewport.addEventListener('resize', update)
    viewport.addEventListener('scroll', update)
    window.addEventListener('orientationchange', update)
    update()
  })

  onBeforeUnmount(() => {
    const viewport = window.visualViewport
    if (!viewport) return

    viewport.removeEventListener('resize', update)
    viewport.removeEventListener('scroll', update)
    window.removeEventListener('orientationchange', update)
  })

  return { layoutBottomOffset, keyboardOpen }
}
