<script setup>
import { computed, ref } from 'vue'
import { useResizeObserver } from '@vueuse/core'

defineProps({
  title: { type: String, default: '' },
  titleClass: { type: String, default: 'text-4xl' },
})

const footerRef = ref(null)
const inlineCreateHeight = ref(0)
const inlineCreateHighlighted = ref(false)
let inlineCreateHighlightTimer = null

const inlineCreateBottomInset =
  'calc(var(--bottom-nav-height, 0px) + 1rem + max(0px, env(safe-area-inset-bottom)))'

useResizeObserver(footerRef, (entries) => {
  const height = entries[0]?.contentRect.height
  if (height != null && height > 0) {
    inlineCreateHeight.value = height
  }
})

const bodyColumnStyle = computed(() => {
  const height = inlineCreateHeight.value
  if (height <= 0) return undefined

  return {
    '--inline-create-height': `${height}px`,
    paddingBottom: `calc(${height}px * 0.5 + var(--bottom-nav-height, 0px) + 1rem + max(0px, env(safe-area-inset-bottom)))`,
  }
})

const footerStickyStyle = computed(() => {
  const height = inlineCreateHeight.value

  return {
    bottom: inlineCreateBottomInset,
    marginTop: height > 0 ? `calc(${height}px * -0.5)` : undefined,
  }
})

function focusFooterInput() {
  const input = footerRef.value?.querySelector?.('[data-slot="input-group-control"]')
  if (!input || typeof input.focus !== 'function') return false
  input.focus()
  return true
}

function scrollToFooterWithHighlight() {
  footerRef.value?.scrollIntoView?.({ behavior: 'smooth', block: 'nearest' })
  focusFooterInput()
  inlineCreateHighlighted.value = true
  if (inlineCreateHighlightTimer != null) {
    clearTimeout(inlineCreateHighlightTimer)
  }
  inlineCreateHighlightTimer = setTimeout(() => {
    inlineCreateHighlighted.value = false
    inlineCreateHighlightTimer = null
  }, 2400)
}

defineExpose({
  scrollToFooterWithHighlight,
  focusFooterInput,
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-6" data-slot="input-action-index-page">
    <header class="flex min-h-9 shrink-0 items-center justify-between gap-3">
      <h1 :class="['min-w-0 font-semibold', titleClass]">
        <slot name="title">{{ title }}</slot>
      </h1>
      <div v-if="$slots.actions" class="flex shrink-0 items-center gap-2">
        <slot name="actions" />
      </div>
    </header>

    <div
      class="input-action-body-column flex min-h-0 flex-1 flex-col"
      :style="bodyColumnStyle"
    >
      <slot />
    </div>

    <div
      v-if="$slots.footer"
      ref="footerRef"
      class="input-action-inline-create sticky z-[1] w-full min-w-0 shrink-0"
      :class="inlineCreateHighlighted && 'input-action-create-highlight'"
      :style="footerStickyStyle"
      data-slot="input-action-index-page-footer"
    >
      <slot name="footer" />
    </div>
  </div>
</template>

<style scoped>
.input-action-body-column {
  --inline-create-height: 5rem;
}

.input-action-inline-create {
  margin-top: calc(var(--inline-create-height) * -0.5);
}

@keyframes input-action-create-ring-pulse {
  0%,
  100% {
    box-shadow: 0 0 0 0 color-mix(in oklab, var(--primary) 0%, transparent);
  }
  40% {
    box-shadow: 0 0 0 4px color-mix(in oklab, var(--primary) 35%, transparent);
  }
}

.input-action-create-highlight :deep([data-slot="input-group"]) {
  animation: input-action-create-ring-pulse 1.1s ease-out 2;
  border-color: var(--primary);
}

@media (prefers-reduced-motion: reduce) {
  .input-action-create-highlight :deep([data-slot="input-group"]) {
    animation: none;
    box-shadow: 0 0 0 3px color-mix(in oklab, var(--primary) 35%, transparent);
  }
}
</style>
