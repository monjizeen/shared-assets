<script setup>
defineProps({
  title: { type: String, required: true },
  description: { type: String, default: '' },
  /** Card inset (dashboard) vs full-height list pane (Quick Actions). */
  compact: { type: Boolean, default: false },
})
</script>

<template>
  <div
    :class="[
      'flex w-full flex-col items-center justify-center gap-3 px-4 text-center',
      compact ? 'min-h-[120px] py-8' : 'min-h-0 flex-1',
    ]"
  >
    <slot name="icon" />
    <p class="text-lg font-medium">{{ title }}</p>
    <p v-if="description" class="max-w-sm text-sm text-muted-foreground">
      {{ description }}
    </p>
    <slot name="action" />
  </div>
</template>
