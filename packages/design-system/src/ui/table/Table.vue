<script setup>
import { cn } from "@monjizeen/design-system/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <div data-slot="table-container" class="relative w-full min-w-0 overflow-auto">
    <table
      data-slot="table"
      :class="cn('w-full min-w-full caption-bottom text-sm', props.class)"
    >
      <slot />
    </table>
  </div>
</template>
