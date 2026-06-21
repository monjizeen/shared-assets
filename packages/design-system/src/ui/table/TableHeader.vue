<script setup>
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <thead
    data-slot="table-header"
    :class="
      cn(
        '[&_tr]:border-b [&_tr]:border-border/50 [&_tr]:bg-transparent [&_tr]:hover:bg-transparent',
        props.class,
      )
    "
  >
    <slot />
  </thead>
</template>
