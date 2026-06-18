<script setup>
import { cn } from "@/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <p
    data-slot="card-description"
    :class="cn('min-w-0 break-words text-muted-foreground text-sm', props.class)"
  >
    <slot />
  </p>
</template>
