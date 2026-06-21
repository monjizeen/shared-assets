<script setup>
import { ref } from 'vue'

import { cn } from '@monjizeen/design-system/lib/utils'
import { useTableHorizontalScrollAffordance } from '@monjizeen/design-system/composables/useTableHorizontalScrollAffordance.js'

const props = defineProps({
  containerClass: { type: null, required: false },
  tableClass: { type: null, required: false },
})

const scrollRef = ref(null)
const tableRef = ref(null)

const { hasOverflow, thumbStyle, pointerScrollTo } = useTableHorizontalScrollAffordance(
  scrollRef,
  tableRef,
)
</script>

<template>
  <div
    data-slot="table-wrapper"
    :class="cn('w-full min-w-0 rounded-lg overflow-hidden', props.containerClass)"
  >
    <div
      ref="scrollRef"
      data-slot="table-scroll"
      :data-use-scroll-affordance="hasOverflow ? 'true' : undefined"
      :class="cn('block w-full min-w-0 overflow-x-auto', hasOverflow && 'touch-pan-x')"
    >
      <table ref="tableRef" :class="cn('w-full min-w-full border-collapse', props.tableClass)">
        <slot />
      </table>
    </div>
    <div v-if="hasOverflow" class="px-1 pb-1 pt-1.5" data-slot="table-scroll-affordance">
      <div
        class="group relative h-2 w-full cursor-pointer rounded-full bg-muted transition-colors duration-200 ease-out motion-reduce:transition-none"
        role="presentation"
        @click="(e) => pointerScrollTo(e.currentTarget, e.clientX)"
      >
        <div
          aria-hidden="true"
          class="box-border pointer-events-none absolute inset-y-0 rounded-full border-2 border-muted bg-muted-foreground bg-clip-padding transition-[inset-inline-start,width,background-color] duration-200 ease-out motion-reduce:transition-none group-hover:bg-foreground"
          :style="thumbStyle"
        />
      </div>
    </div>
  </div>
</template>
