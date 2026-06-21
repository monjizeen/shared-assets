<script setup>
import { reactiveOmit } from "@vueuse/core";
import {
  ComboboxContent,
  ComboboxPortal,
  ComboboxViewport,
  useForwardPropsEmits,
} from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";

defineOptions({
  inheritAttrs: false,
});

const props = defineProps({
  forceMount: { type: Boolean, required: false },
  position: { type: String, required: false, default: "popper" },
  bodyLock: { type: Boolean, required: false },
  side: { type: null, required: false },
  sideOffset: { type: Number, required: false },
  sideFlip: { type: Boolean, required: false },
  align: { type: null, required: false },
  alignOffset: { type: Number, required: false },
  alignFlip: { type: Boolean, required: false },
  avoidCollisions: { type: Boolean, required: false },
  collisionBoundary: { type: null, required: false },
  collisionPadding: { type: [Number, Object], required: false },
  arrowPadding: { type: Number, required: false },
  hideShiftedArrow: { type: Boolean, required: false },
  sticky: { type: String, required: false },
  hideWhenDetached: { type: Boolean, required: false },
  positionStrategy: { type: String, required: false },
  updatePositionStrategy: { type: String, required: false },
  disableUpdateOnLayoutShift: { type: Boolean, required: false },
  prioritizePosition: { type: Boolean, required: false },
  reference: { type: null, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  disableOutsidePointerEvents: { type: Boolean, required: false },
  class: { type: null, required: false },
});

const emits = defineEmits([
  "escapeKeyDown",
  "pointerDownOutside",
  "focusOutside",
  "interactOutside",
  "closeAutoFocus",
]);

const delegatedProps = reactiveOmit(props, "class");
const forwarded = useForwardPropsEmits(delegatedProps, emits);

const contentClass = cn(
  "bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=open]:duration-500 data-[state=closed]:duration-300 data-[state=open]:ease-[cubic-bezier(0.22,1,0.36,1)] data-[state=closed]:ease-[cubic-bezier(0.55,0,1,0.45)] data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 z-50 flex max-h-[min(24rem,var(--reka-combobox-content-available-height))] min-w-[8rem] flex-col overflow-hidden rounded-md border shadow-md",
  props.position === "popper" &&
    "data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",
  props.class,
);

const viewportClass = cn(
  "p-1",
  props.position === "popper" &&
    "w-full min-w-[var(--reka-combobox-trigger-width)] scroll-my-1",
);
</script>

<template>
  <ComboboxPortal v-if="position === 'popper'">
    <ComboboxContent
      data-slot="combobox-content"
      v-bind="{ ...$attrs, ...forwarded }"
      :class="contentClass"
    >
      <ComboboxViewport :class="viewportClass">
        <slot />
      </ComboboxViewport>
    </ComboboxContent>
  </ComboboxPortal>
  <ComboboxContent
    v-else
    data-slot="combobox-content"
    v-bind="{ ...$attrs, ...forwarded }"
    :class="contentClass"
  >
    <ComboboxViewport :class="viewportClass">
      <slot />
    </ComboboxViewport>
  </ComboboxContent>
</template>
