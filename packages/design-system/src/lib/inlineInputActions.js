/** Max inline actions before overflow menu kicks in. */
export const INLINE_INPUT_MAX_INLINE_ACTIONS = 3

/** When action count exceeds max, show this many inline; rest go in More menu. */
export const INLINE_INPUT_VISIBLE_WHEN_OVERFLOW = 2

export function shouldOverflowInlineInputActions(count) {
  return count > INLINE_INPUT_MAX_INLINE_ACTIONS
}

export function inlineInputActionsVisibleCount(count) {
  return shouldOverflowInlineInputActions(count)
    ? INLINE_INPUT_VISIBLE_WHEN_OVERFLOW
    : count
}
