<script setup>
import { computed, useSlots } from 'vue'
import { cn } from "@monjizeen/design-system/lib/utils"

const props = defineProps({
  /** Sort key for this column */
  sortKey: { type: String, required: true },
  /** Current active sort key (from useTableSort) */
  currentSortBy: { type: String, default: null },
  /** Current direction: 'asc' | 'desc' */
  currentSortDir: { type: String, default: 'asc' },
  /** Header label (slot can be used instead) */
  label: { type: String, default: '' },
  /** Alignment: 'left' | 'right' | 'center' */
  align: { type: String, default: 'left' },
  /** Additional class for the th */
  class: { type: null, default: null },
})

const emit = defineEmits(['click'])

const slots = useSlots()
const hasTrailing = computed(() => typeof slots.trailing === 'function')

function onClick() {
  emit('click', props.sortKey)
}
</script>

<template>
  <th
    data-slot="table-head"
    role="button"
    tabindex="0"
    :class="
      cn(
        'text-foreground h-10 px-2 text-start align-middle font-normal whitespace-nowrap cursor-pointer select-none hover:bg-muted/50 transition-colors [&:has([role=checkbox])]:pe-0 [&>[role=checkbox]]:translate-y-[2px]',
        hasTrailing && 'relative pe-3',
        align === 'right' && 'text-end',
        align === 'center' && 'text-center',
        props.class,
      )
    "
    @click="onClick"
    @keydown.enter="onClick"
    @keydown.space.prevent="onClick"
  >
    <span class="inline-flex items-center gap-1">
      <slot>{{ label }}</slot>
    </span>
    <slot name="trailing" />
  </th>
</template>
