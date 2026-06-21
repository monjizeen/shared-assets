<script setup>
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <div
    data-slot="card"
    :class="
      cn(
        'text-card-foreground flex min-w-0 flex-col gap-3 rounded-xl py-6',
        props.class,
      )
    "
  >
    <slot />
  </div>
</template>
