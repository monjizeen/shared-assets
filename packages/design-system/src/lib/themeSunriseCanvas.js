/**
 * Theme canvas based on sunrise_sunset_v6_sun_50_opacity:
 * linear night↔day gradient and sun at 50% max opacity.
 */

export const THEME_SUNRISE_DURATION_MS = 1800

/** @param {string} raw */
export function parseCssColorToRgb(raw) {
  if (!raw) return null
  const s = raw.trim()
  if (!s) return null
  const hex6 = /^#([0-9a-f]{6})$/i.exec(s)
  const hex3 = /^#([0-9a-f]{3})$/i.exec(s)
  if (hex6) {
    const n = parseInt(hex6[1], 16)
    return [(n >> 16) & 255, (n >> 8) & 255, n & 255]
  }
  if (hex3) {
    const h = hex3[1]
    const r = parseInt(h[0] + h[0], 16)
    const g = parseInt(h[1] + h[1], 16)
    const b = parseInt(h[2] + h[2], 16)
    return [r, g, b]
  }
  const rgbFn = /^rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)/i.exec(s)
  if (rgbFn) {
    return [+rgbFn[1], +rgbFn[2], +rgbFn[3]]
  }
  return null
}

/**
 * Read light or dark app background RGB from CSS custom properties (--background-surface-*).
 * @param {boolean} isDark true = dark surface token
 * @returns {[number, number, number]}
 */
export function getThemeSurfaceRgb(isDark) {
  if (typeof document === 'undefined') {
    return isDark ? [9, 9, 11] : [250, 250, 250]
  }
  const prop = isDark ? '--background-surface-dark' : '--background-surface-light'
  const raw = getComputedStyle(document.documentElement).getPropertyValue(prop).trim()
  const parsed = parseCssColorToRgb(raw)
  if (parsed) return parsed
  return isDark ? [9, 9, 11] : [250, 250, 250]
}

export function ease(t) {
  return t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2
}

function lerp(a, b, t) {
  return a + (b - a) * t
}

function lerpC(a, b, t) {
  return [lerp(a[0], b[0], t), lerp(a[1], b[1], t), lerp(a[2], b[2], t)]
}

function rgb(c) {
  return `rgb(${Math.round(c[0])},${Math.round(c[1])},${Math.round(c[2])})`
}

const CREAM_TOP = [250, 250, 250]
const CREAM_BOT = [244, 244, 245]
/** Fallback when CSS is unavailable; keep in sync with resources/css/app-theme.css --background-surface-dark */
const NIGHT_SURFACE_TOP = [9, 9, 11]
const NIGHT_SURFACE_BOT = [9, 9, 11]

/**
 * @param {CanvasRenderingContext2D} ctx
 * @param {number} W
 * @param {number} H
 * @param {number} rawProgress 0–1 before easing (sunrise: 0→1, sunset: 1→0 from caller)
 * @param {{ from: [number, number, number], toLight: boolean }} spec
 */
/**
 * @param {{ from?: [number, number, number], toLight?: boolean, dayLightTop?: [number, number, number], dayLightBottom?: [number, number, number] }} spec
 */
export function drawSunriseFrame(ctx, W, H, rawProgress, spec) {
  const tEase = ease(rawProgress)
  /** 0 = night, 1 = day (overlay passes 0→1 sunrise, 1→0 sunset). */
  const u = tEase

  const dayTop = spec?.dayLightTop ?? CREAM_TOP
  const dayBot = spec?.dayLightBottom ?? CREAM_BOT

  const topC = lerpC(NIGHT_SURFACE_TOP, dayTop, u)
  const botC = lerpC(NIGHT_SURFACE_BOT, dayBot, u)

  const grd = ctx.createLinearGradient(0, 0, 0, H)
  grd.addColorStop(0, rgb(topC))
  grd.addColorStop(1, rgb(botC))
  ctx.fillStyle = grd
  ctx.fillRect(0, 0, W, H)

  if (u > 0.03 && u < 0.97) {
    const sunT = u < 0.5 ? u / 0.5 : (1 - u) / 0.5
    const a = Math.min(0.5, sunT * 1.1)
    const sy = H * 0.92 - u * H * 0.84
    const glowSize = 140
    const gl = ctx.createRadialGradient(W / 2, sy, 10, W / 2, sy, glowSize)
    gl.addColorStop(0, `rgba(255,180,80,${0.35 * a})`)
    gl.addColorStop(0.3, `rgba(255,140,60,${0.15 * a})`)
    gl.addColorStop(1, 'rgba(255,140,60,0)')
    ctx.fillStyle = gl
    ctx.fillRect(0, 0, W, H)
    ctx.beginPath()
    ctx.arc(W / 2, sy, 24, 0, Math.PI * 2)
    const sc =
      u < 0.5
        ? lerpC([255, 100, 40], [255, 210, 120], u * 2)
        : lerpC([255, 210, 120], [255, 245, 200], (u - 0.5) * 2)
    ctx.fillStyle = `rgba(${Math.round(sc[0])},${Math.round(sc[1])},${Math.round(sc[2])},${a})`
    ctx.fill()
  }
}
