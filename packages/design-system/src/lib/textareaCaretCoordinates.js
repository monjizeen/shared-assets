/** CSS properties mirrored when measuring textarea caret position. */
const MIRROR_PROPERTIES = [
  'direction',
  'boxSizing',
  'width',
  'height',
  'overflowX',
  'overflowY',
  'borderTopWidth',
  'borderRightWidth',
  'borderBottomWidth',
  'borderLeftWidth',
  'borderStyle',
  'paddingTop',
  'paddingRight',
  'paddingBottom',
  'paddingLeft',
  'fontStyle',
  'fontVariant',
  'fontWeight',
  'fontStretch',
  'fontSize',
  'fontSizeAdjust',
  'lineHeight',
  'fontFamily',
  'textAlign',
  'textTransform',
  'textIndent',
  'textDecoration',
  'letterSpacing',
  'wordSpacing',
  'tabSize',
  'MozTabSize',
]

/**
 * Viewport coordinates for a caret index inside a `<textarea>`.
 * @param {HTMLTextAreaElement} textarea
 * @param {number} position
 * @returns {{ top: number, left: number }}
 */
export function getTextareaCaretCoordinates(textarea, position) {
  const div = document.createElement('div')
  document.body.appendChild(div)

  const mirrorStyle = div.style
  const computed = window.getComputedStyle(textarea)

  mirrorStyle.whiteSpace = 'pre-wrap'
  mirrorStyle.wordWrap = 'break-word'
  mirrorStyle.position = 'absolute'
  mirrorStyle.visibility = 'hidden'

  for (const prop of MIRROR_PROPERTIES) {
    mirrorStyle[prop] = computed[prop]
  }

  mirrorStyle.overflow = 'hidden'
  mirrorStyle.width = `${textarea.offsetWidth}px`

  const textBefore = textarea.value.substring(0, position)
  div.textContent = textBefore

  const span = document.createElement('span')
  span.textContent = textarea.value.substring(position) || '.'
  div.appendChild(span)

  const borderTop = Number.parseInt(computed.borderTopWidth, 10) || 0
  const borderLeft = Number.parseInt(computed.borderLeftWidth, 10) || 0
  const paddingTop = Number.parseInt(computed.paddingTop, 10) || 0
  const paddingLeft = Number.parseInt(computed.paddingLeft, 10) || 0

  const relativeTop = span.offsetTop + borderTop + paddingTop
  const relativeLeft = span.offsetLeft + borderLeft + paddingLeft

  document.body.removeChild(div)

  const rect = textarea.getBoundingClientRect()

  return {
    top: rect.top + relativeTop - textarea.scrollTop,
    left: rect.left + relativeLeft - textarea.scrollLeft,
  }
}
