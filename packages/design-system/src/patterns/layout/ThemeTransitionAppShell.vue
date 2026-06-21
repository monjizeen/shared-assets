<script setup>
import { computed } from 'vue'
import { theme } from '@monjizeen/design-system/store/theme.js'

const shellClass = computed(() => [
  'flex min-h-dvh w-full flex-1 flex-col transition-opacity duration-700 ease-out motion-reduce:transition-none',
  theme.transitionActive
    ? 'pointer-events-none opacity-0'
    : 'pointer-events-auto opacity-100',
])
</script>

<template>
  <div :class="shellClass">
    <slot />
  </div>
</template>
