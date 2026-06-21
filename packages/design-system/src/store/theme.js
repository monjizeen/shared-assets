import { reactive } from 'vue'
import { getThemeSurfaceRgb } from '@monjizeen/design-system/lib/themeSunriseCanvas.js'

const STORAGE_KEY = typeof import.meta !== 'undefined' && import.meta.env?.VITE_DS_THEME_STORAGE_KEY || 'app-theme'

function isDarkMode(store) {
  if (store.mode === 'dark') return true
  if (store.mode === 'light') return false
  return store.systemPrefersDark
}

function prefersReducedMotion() {
  return (
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches
  )
}

function applyFromStore(store) {
  if (typeof document === 'undefined') return
  if (store.transitionLocked) return
  document.documentElement.classList.toggle('dark', isDarkMode(store))
}

let mediaQuery = null

function attachSystemListener(store) {
  if (typeof window === 'undefined') return
  mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
  store.systemPrefersDark = mediaQuery.matches
  mediaQuery.addEventListener('change', (e) => {
    store.systemPrefersDark = e.matches
    if (!store.transitionLocked) applyFromStore(store)
  })
}

export const theme = reactive({
  /** User preference: follow OS, or force light/dark */
  mode: 'system',
  /** Cached (prefers-color-scheme: dark); only affects appearance when mode === 'system' */
  systemPrefersDark: false,

  /** Fullscreen canvas transition running; blocks updating the dark class on the root until finished */
  transitionActive: false,
  /** When true, animates progress 0→1 (sunrise to light); when false, 1→0 (sunset to dark) */
  transitionToLight: true,
  transitionLocked: false,
  /** @type {[number, number, number] | null} RGB for canvas start (site surface being left) */
  transitionFromRgb: null,

  init() {
    attachSystemListener(this)
    try {
      const stored = localStorage.getItem(STORAGE_KEY)
      if (stored === 'light' || stored === 'dark' || stored === 'system') {
        this.mode = stored
      }
    } catch {
      /* ignore quota / private mode */
    }
    applyFromStore(this)
  },

  /**
   * Apply pending theme to the document after the canvas transition completes
   * (or immediately when transitions are skipped).
   */
  finishThemeTransition() {
    this.transitionActive = false
    this.transitionLocked = false
    this.transitionFromRgb = null
    applyFromStore(this)
  },

  setMode(mode) {
    if (this.transitionActive) return

    const prevEffective = isDarkMode(this)
    this.mode = mode
    try {
      localStorage.setItem(STORAGE_KEY, mode)
    } catch {
      /* ignore quota / private mode */
    }

    const nextEffective = isDarkMode(this)

    if (prevEffective === nextEffective || prefersReducedMotion()) {
      applyFromStore(this)
      return
    }

    this.transitionFromRgb = getThemeSurfaceRgb(prevEffective)
    this.transitionLocked = true
    this.transitionToLight = !nextEffective
    this.transitionActive = true
  },

  /** Compact toggle behavior: system defaults until first choice, then light/dark only */
  cycleMode() {
    if (this.transitionActive) return
    if (this.mode === 'system') {
      // First explicit selection exits system mode and stores a concrete preference.
      this.setMode(this.effectiveDark ? 'light' : 'dark')
      return
    }
    this.setMode(this.mode === 'light' ? 'dark' : 'light')
  },

  get effectiveDark() {
    return isDarkMode(this)
  },
})
