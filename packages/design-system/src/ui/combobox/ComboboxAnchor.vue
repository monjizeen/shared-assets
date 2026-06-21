<script setup>
import { ComboboxAnchor } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  reference: { type: null, required: false },
});
</script>

<template>
  <ComboboxAnchor
    data-slot="combobox-anchor"
    v-bind="$attrs"
    :as="props.as"
    :as-child="props.asChild"
    :reference="props.reference"
    :class="cn('relative w-full', props.class)"
  >
    <slot />
  </ComboboxAnchor>
</template>
