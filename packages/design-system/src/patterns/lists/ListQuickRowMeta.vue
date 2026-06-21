<script setup>
/** Secondary meta line (dates, author) below primary row content. */
</script>

<template>
  <div
    class="flex w-full min-w-0 flex-wrap items-baseline gap-x-3 gap-y-1 text-xs text-muted-foreground"
    data-slot="list-quick-row-meta"
  >
    <slot />
  </div>
</template>
