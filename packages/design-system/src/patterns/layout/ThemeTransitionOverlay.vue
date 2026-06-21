<script setup>
import { onBeforeUnmount, ref, watch } from 'vue'
import { theme } from '@monjizeen/design-system/store/theme.js'
import {
  THEME_SUNRISE_DURATION_MS,
  drawSunriseFrame,
  getThemeSurfaceRgb,
} from '@monjizeen/design-system/lib/themeSunriseCanvas.js'

const canvasRef = ref(null)
let rafId = 0
let startTime = 0
/** @type {[number, number, number]} */
let transitionDayLightTop = [250, 250, 250]
/** @type {[number, number, number]} */
let transitionDayLightBottom = [244, 244, 245]

function prefersReducedMotion() {
  return (
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches
  )
}

function resizeCanvas() {
  const cv = canvasRef.value
  if (!cv || typeof window === 'undefined') return
  const ctx = cv.getContext('2d')
  if (!ctx) return
  const W = window.innerWidth
  const H = window.innerHeight
  const dpr = window.devicePixelRatio || 1
  cv.width = W * dpr
  cv.height = H * dpr
  cv.style.width = `${W}px`
  cv.style.height = `${H}px`
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
}

function stopRaf() {
  if (rafId) {
    cancelAnimationFrame(rafId)
    rafId = 0
  }
  startTime = 0
}

function finishFromReducedMotion() {
  stopRaf()
  theme.finishThemeTransition()
}

function animate(timestamp) {
  const cv = canvasRef.value
  if (!cv || !theme.transitionActive) {
    stopRaf()
    return
  }
  const ctx = cv.getContext('2d')
  if (!ctx) {
    theme.finishThemeTransition()
    return
  }
  if (!startTime) startTime = timestamp
  const elapsed = timestamp - startTime
  const rawT = Math.min(elapsed / THEME_SUNRISE_DURATION_MS, 1)

  const toLight = theme.transitionToLight
  const progress = toLight ? rawT : 1 - rawT

  const W = window.innerWidth
  const H = window.innerHeight
  const from = theme.transitionFromRgb
  drawSunriseFrame(ctx, W, H, progress, {
    from: from ?? [128, 128, 128],
    toLight: theme.transitionToLight,
    dayLightTop: transitionDayLightTop,
    dayLightBottom: transitionDayLightBottom,
  })

  if (rawT < 1) {
    rafId = requestAnimationFrame(animate)
  } else {
    stopRaf()
    theme.finishThemeTransition()
  }
}

function startTransition() {
  if (!theme.transitionActive) return
  if (prefersReducedMotion()) {
    finishFromReducedMotion()
    return
  }
  const rgb = getThemeSurfaceRgb(false)
  transitionDayLightTop = rgb
  transitionDayLightBottom = [
    Math.max(0, rgb[0] - 10),
    Math.max(0, rgb[1] - 11),
    Math.max(0, rgb[2] - 12),
  ]
  resizeCanvas()
  stopRaf()
  startTime = 0
  rafId = requestAnimationFrame(animate)
}

function onResize() {
  if (!theme.transitionActive) return
  resizeCanvas()
}

watch(
  () => theme.transitionActive,
  (active) => {
    if (active) {
      startTransition()
      window.addEventListener('resize', onResize)
    } else {
      stopRaf()
      window.removeEventListener('resize', onResize)
    }
  },
)

onBeforeUnmount(() => {
  stopRaf()
  window.removeEventListener('resize', onResize)
})
</script>

<template>
  <Teleport to="#theme-transition-anchor">
    <canvas
      v-show="theme.transitionActive"
      ref="canvasRef"
      class="pointer-events-none absolute inset-0 block h-full w-full"
      aria-hidden="true"
    />
  </Teleport>
</template>
