<script setup>
import { reactiveOmit } from "@vueuse/core";
import { ChevronRight } from "lucide-vue-next";
import { DropdownMenuSubTrigger, useForwardProps } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";
import { dropdownMenuSubTriggerClasses } from "./itemClasses.js";

const props = defineProps({
  disabled: { type: Boolean, required: false },
  textValue: { type: String, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  class: { type: null, required: false },
  inset: { type: Boolean, required: false },
});

const delegatedProps = reactiveOmit(props, "class", "inset");
const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <DropdownMenuSubTrigger
    data-slot="dropdown-menu-sub-trigger"
    v-bind="forwardedProps"
    :class="
      cn(
        dropdownMenuSubTriggerClasses,
        props.class,
      )
    "
  >
    <slot />
    <ChevronRight class="ms-auto size-4 rtl:rotate-180" aria-hidden="true" />
  </DropdownMenuSubTrigger>
</template>
