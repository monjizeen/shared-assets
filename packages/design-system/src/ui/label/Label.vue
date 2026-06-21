<script setup>
import { reactiveOmit } from "@vueuse/core";
import { Label } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  for: { type: String, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  class: { type: null, required: false },
  /** Smaller, regular-weight caption for filter popovers and dense UIs */
  variant: {
    type: String,
    default: "default",
    validator: (v) => ["default", "filter"].includes(v),
  },
});

const delegatedProps = reactiveOmit(props, "class", "variant");
</script>

<template>
  <Label
    data-slot="label"
    v-bind="delegatedProps"
    :class="
      cn(
        'flex items-center gap-2 select-none group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50',
        props.variant === 'filter'
          ? 'text-xs leading-none font-normal text-muted-foreground'
          : 'text-sm leading-none font-medium',
        props.class,
      )
    "
  >
    <slot />
  </Label>
</template>
