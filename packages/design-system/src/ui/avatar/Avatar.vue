<script setup>
import { AvatarRoot } from "reka-ui";
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});

const smallerAvatarSizeClasses = {
  "size-16": "size-14",
  "size-14": "size-12",
  "size-12": "size-11",
  "size-8": "size-7",
  "size-7": "size-6",
  "size-6": "size-5",
  "size-5": "size-4",
  "size-4": "size-3.5",
  "h-20": "h-[4.5rem]",
  "w-20": "w-[4.5rem]",
  "h-9": "h-8",
  "w-9": "w-8",
  "h-8": "h-7",
  "w-8": "w-7",
};

function shrinkAvatarSizeClass(value) {
  if (typeof value === "string") {
    return value
      .split(/\s+/)
      .filter(Boolean)
      .map((className) => smallerAvatarSizeClasses[className] ?? className)
      .join(" ");
  }

  if (Array.isArray(value)) {
    return value.map(shrinkAvatarSizeClass);
  }

  if (value && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value).map(([className, enabled]) => [
        shrinkAvatarSizeClass(className),
        enabled,
      ]),
    );
  }

  return value;
}
</script>

<template>
  <AvatarRoot
    data-slot="avatar"
    :class="
      cn(
        'relative flex size-7 shrink-0 overflow-hidden rounded-full',
        shrinkAvatarSizeClass(props.class),
      )
    "
  >
    <slot />
  </AvatarRoot>
</template>
