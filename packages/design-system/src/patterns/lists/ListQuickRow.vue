<script setup>
/**
 * Shared quick-actions list row shell (work logs, projects, orgs, users).
 * Content column grows; actions stay intrinsic width so meta text is not squeezed.
 */
</script>

<template>
  <li
    class="group/quick-row flex flex-col px-3 py-3 transition-colors duration-200 ease-out hover:bg-muted/25"
    data-slot="list-quick-row"
  >
    <div class="flex w-full items-center gap-3">
      <slot name="leading" />
      <div class="min-w-0 flex-1 basis-0">
        <slot />
      </div>
      <div
        v-if="$slots.actions"
        :class="[
          'ms-auto flex shrink-0 flex-wrap items-center justify-end gap-2',
          $slots['mobile-actions'] ? 'hidden sm:flex' : '',
        ]"
        data-slot="list-quick-row-actions"
      >
        <slot name="actions" />
      </div>
      <div v-if="$slots['mobile-actions']" class="ms-auto shrink-0 sm:hidden">
        <slot name="mobile-actions" />
      </div>
    </div>
  </li>
</template>
