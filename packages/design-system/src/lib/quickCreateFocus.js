/** @type {(() => void) | null} */
let focusHandler = null

/** @param {() => void} fn */
export function registerQuickCreateFocusHandler(fn) {
  focusHandler = fn
}

export function unregisterQuickCreateFocusHandler() {
  focusHandler = null
}

export function requestQuickCreateFocus() {
  focusHandler?.()
}
