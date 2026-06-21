import { nextTick } from 'vue'

/**
 * First real `<input>` in document order (entry controls, not chrome buttons).
 * Skips checkbox/radio so “first field” means primary text entry, not ancillary toggles.
 */
export const FIRST_INPUT_SELECTOR =
  'input:not([type="hidden"]):not([type="button"]):not([type="submit"]):not([type="reset"]):not([type="image"]):not([type="checkbox"]):not([type="radio"]):not([disabled]):not([tabindex="-1"])'

const FALLBACK_TEXTAREA = 'textarea:not([disabled]):not([tabindex="-1"])'
const FALLBACK_SELECT = 'select:not([disabled]):not([tabindex="-1"])'
/** Reka/shadcn Select trigger (button). */
const FALLBACK_SELECT_TRIGGER = '[data-slot="select-trigger"]:not([disabled]):not([tabindex="-1"])'
/** TipTap / rich text (ProseMirror). */
const FALLBACK_CONTENTEDITABLE = '[contenteditable="true"]:not([tabindex="-1"])'

function isFocusableField(el) {
  if (!(el instanceof HTMLElement)) return false
  const style = getComputedStyle(el)
  if (style.visibility === 'hidden' || style.display === 'none') return false
  return true
}

/**
 * @param {HTMLElement} el
 * @returns {boolean}
 */
function applyFocus(el) {
  if (!(el instanceof HTMLElement) || !isFocusableField(el)) return false
  el.focus({ preventScroll: true })
  if (document.activeElement !== el) return false
  if (
    el instanceof HTMLInputElement
    && typeof el.select === 'function'
    && ['text', 'search', 'url', 'tel', 'email', 'password'].includes(el.type)
  ) {
    try {
      el.select()
    } catch {
      /* readonly or other */
    }
  }
  return true
}

/**
 * Focus the first visible `<input>` inside root; if none can take focus, textarea then select.
 * @param {HTMLElement} root
 * @returns {Promise<boolean>}
 */
export async function focusFirstFormField(root) {
  await nextTick()
  await nextTick()

  if (focusFirstInLists(root)) return true

  await new Promise((r) => {
    requestAnimationFrame(r)
  })
  return focusFirstInLists(root)
}

/**
 * @param {HTMLElement} root
 * @returns {boolean}
 */
function focusFirstInLists(root) {
  for (const el of root.querySelectorAll(FIRST_INPUT_SELECTOR)) {
    if (applyFocus(el)) return true
  }
  for (const el of root.querySelectorAll(FALLBACK_TEXTAREA)) {
    if (applyFocus(el)) return true
  }
  for (const el of root.querySelectorAll(FALLBACK_SELECT)) {
    if (applyFocus(el)) return true
  }
  for (const el of root.querySelectorAll(FALLBACK_SELECT_TRIGGER)) {
    if (applyFocus(el)) return true
  }
  for (const el of root.querySelectorAll(FALLBACK_CONTENTEDITABLE)) {
    if (applyFocus(el)) return true
  }
  return false
}

/**
 * Reka Dialog auto-focus runs before slot fields are mounted. Prevent default and focus after paint.
 *
 * @param {Event} event
 */
export function handleDialogOpenAutoFocus(event) {
  const root = event.target
  if (!(root instanceof HTMLElement)) return

  event.preventDefault()

  void (async () => {
    const moved = await focusFirstFormField(root)
    if (!moved && typeof root.focus === 'function') {
      root.focus({ preventScroll: true })
    }
  })()
}
