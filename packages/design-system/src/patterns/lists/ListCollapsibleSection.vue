<script setup>
import { computed } from 'vue'
import { ChevronDown } from 'lucide-vue-next'

const props = defineProps({
  sectionKey: { type: String, required: true },
  title: { type: String, required: true },
  expanded: { type: Boolean, required: true },
  count: { type: Number, default: null },
})

const emit = defineEmits(['toggle'])

const contentId = computed(() => `list-section-${props.sectionKey}`)

function onToggle() {
  emit('toggle', props.sectionKey)
}
</script>

<template>
  <section class="space-y-2">
    <button
      type="button"
      class="interactive-press flex w-full items-center gap-2 rounded-md px-1 py-1 text-start transition-colors hover:bg-muted/30 focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50"
      :aria-expanded="expanded"
      :aria-controls="contentId"
      @click="onToggle"
    >
      <ChevronDown
        class="size-4 shrink-0 text-muted-foreground transition-transform duration-200 ease-out motion-reduce:transition-none"
        :class="expanded ? 'rotate-180' : ''"
        aria-hidden="true"
      />
      <span class="min-w-0 flex-1 text-sm font-medium text-muted-foreground">
        {{ title }}
      </span>
      <span
        v-if="count != null"
        class="shrink-0 text-xs tabular-nums text-muted-foreground/80"
      >
        {{ count }}
      </span>
    </button>
    <div
      v-show="expanded"
      :id="contentId"
    >
      <slot />
    </div>
  </section>
</template>
