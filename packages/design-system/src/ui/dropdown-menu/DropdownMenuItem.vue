<script setup>
import { reactiveOmit } from "@vueuse/core";
import { DropdownMenuItem, useForwardProps } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";
import {
  dropdownMenuItemClasses,
  dropdownMenuItemDestructiveClasses,
  dropdownMenuItemIconClasses,
} from "./itemClasses.js";

const props = defineProps({
  disabled: { type: Boolean, required: false },
  textValue: { type: String, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  class: { type: null, required: false },
  inset: { type: Boolean, required: false },
  variant: { type: String, required: false, default: "default" },
});

const delegatedProps = reactiveOmit(props, "inset", "variant", "class");

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <DropdownMenuItem
    data-slot="dropdown-menu-item"
    :data-inset="inset ? '' : undefined"
    :data-variant="variant"
    v-bind="forwardedProps"
    :class="
      cn(
        dropdownMenuItemClasses,
        dropdownMenuItemDestructiveClasses,
        dropdownMenuItemIconClasses,
        props.class,
      )
    "
  >
    <slot />
  </DropdownMenuItem>
</template>
