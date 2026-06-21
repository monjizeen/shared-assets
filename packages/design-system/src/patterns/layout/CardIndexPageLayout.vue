<script setup>
import { Card, CardContent } from '@monjizeen/design-system/ui/card'

defineProps({
  /** Page heading when the title slot is not used. */
  title: { type: String, default: '' },
  /** `text-4xl` for primary index pages; `text-3xl` for admin sub-pages. */
  titleClass: { type: String, default: 'text-4xl' },
})
</script>

<template>
  <div class="space-y-6" data-slot="card-index-page">
    <header class="flex min-h-9 shrink-0 items-center justify-between gap-3">
      <h1 :class="['min-w-0 font-semibold', titleClass]">
        <slot name="title">{{ title }}</slot>
      </h1>
      <div v-if="$slots.actions" class="flex shrink-0 items-center gap-2">
        <slot name="actions" />
      </div>
    </header>

    <Card class="min-w-0">
      <CardContent class="min-w-0">
        <slot />
      </CardContent>
    </Card>

    <div v-if="$slots.footer" class="shrink-0" data-slot="card-index-page-footer">
      <slot name="footer" />
    </div>
  </div>
</template>
