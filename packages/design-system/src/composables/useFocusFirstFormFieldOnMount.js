import { unref, watch } from 'vue'
import { focusFirstFormField } from '@monjizeen/design-system/lib/focusFirstFormField.js'

/**
 * @param {unknown} raw
 * @returns {HTMLElement | null}
 */
function formFocusRootEl(raw) {
  if (raw instanceof HTMLElement) return raw
  const el = raw && typeof raw === 'object' && '$el' in raw ? raw.$el : null
  return el instanceof HTMLElement ? el : null
}

/**
 * Focus the first text-entry control inside `root` when it appears (page mount or v-if).
 * Dialogs use `DialogContent` `@open-auto-focus` + `handleDialogOpenAutoFocus` instead.
 *
 * @param {import('vue').Ref<HTMLElement | import('vue').ComponentPublicInstance | null | undefined>} root
 */
export function useFocusFirstFormFieldOnMount(root) {
  watch(
    () => formFocusRootEl(unref(root)),
    (el) => {
      if (!el) return
      void focusFirstFormField(el)
    },
    { flush: 'post', immediate: true },
  )
}
