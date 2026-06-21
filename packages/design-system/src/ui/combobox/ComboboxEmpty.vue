<script setup>
import { ComboboxEmpty } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
});
</script>

<template>
  <ComboboxEmpty
    data-slot="combobox-empty"
    :class="cn('px-2 py-1.5 text-center text-sm text-muted-foreground', props.class)"
  >
    <slot>No matches</slot>
  </ComboboxEmpty>
</template>
