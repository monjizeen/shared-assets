<script setup>
/** Leading circle icon for quick-action list rows. */
</script>

<template>
  <div
    class="flex size-6 shrink-0 items-center justify-center rounded-full border border-border/80 bg-background"
    data-slot="list-quick-row-icon"
  >
    <slot />
  </div>
</template>
