<script setup>
import { computed, ref, useSlots } from 'vue'
import { cn } from '@monjizeen/design-system/lib/utils'
import { useInlineInputExpanded } from '@monjizeen/design-system/composables/useInlineInputExpanded'

const props = defineProps({
  disabled: { type: Boolean, default: false },
  invalid: { type: Boolean, default: false },
  /** Re-measure expanded layout when bound text changes. */
  text: { type: String, default: '' },
})

const slots = useSlots()
const hasStart = computed(() => Boolean(slots.start))

const controlWrapRef = ref(null)
const { expanded } = useInlineInputExpanded(controlWrapRef, () => props.text)

const shellClass = computed(() =>
  cn(
    'group/input-group relative w-full min-w-0 gap-1 rounded-[24px] border border-input bg-card p-1.5 shadow-xs transition-[color,box-shadow]',
    'has-[[data-slot=input-group-control]:focus-visible]:border-ring has-[[data-slot=input-group-control]:focus-visible]:ring-[3px] has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50',
    props.disabled && 'opacity-50',
    props.invalid && 'border-destructive ring-[3px] ring-destructive/20 dark:ring-destructive/40',
    expanded.value
      ? hasStart.value
        ? 'grid grid-cols-[1fr_auto] grid-rows-[auto_auto]'
        : 'grid grid-cols-1 grid-rows-[auto_auto]'
      : hasStart.value
        ? 'grid grid-cols-[auto_1fr_auto] items-center'
        : 'grid grid-cols-[1fr_auto] items-center',
  ),
)

const startClass = computed(() =>
  cn(
    'flex shrink-0 items-center self-center',
    expanded.value
      ? 'col-start-1 row-start-2'
      : 'col-start-1 row-start-1',
  ),
)

const controlWrapClass = computed(() =>
  cn(
    'min-w-0',
    expanded.value
      ? 'col-span-full row-start-1 w-full'
      : hasStart.value
        ? 'col-start-2 row-start-1'
        : 'col-start-1 row-start-1',
  ),
)

const endClass = computed(() =>
  cn(
    'flex shrink-0 items-center gap-0.5 self-center max-w-full overflow-x-auto',
    expanded.value
      ? hasStart.value
        ? 'col-start-2 row-start-2 justify-self-end'
        : 'col-start-1 row-start-2 justify-self-end'
      : hasStart.value
        ? 'col-start-3 row-start-1'
        : 'col-start-2 row-start-1',
  ),
)
</script>

<template>
  <div
    data-slot="input-group"
    role="group"
    :class="shellClass"
  >
    <div
      v-if="hasStart"
      data-slot="input-group-start"
      :class="startClass"
    >
      <slot name="start" />
    </div>

    <div
      ref="controlWrapRef"
      :class="controlWrapClass"
    >
      <slot />
    </div>

    <div
      data-slot="input-group-end"
      :class="endClass"
    >
      <slot name="end" />
    </div>
  </div>
</template>
