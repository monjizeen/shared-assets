<script setup>
defineProps({
  ariaLabel: { type: String, required: true },
})

const emit = defineEmits(['resizeStart'])

function onPointerDown(e) {
  emit('resizeStart', e)
}
</script>

<template>
  <button
    type="button"
    class="absolute end-0 top-0 z-[2] h-full w-3 cursor-col-resize touch-none border-0 bg-transparent p-0 hover:bg-primary/15 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
    :aria-label="ariaLabel"
    @pointerdown="onPointerDown"
    @click.stop
  />
</template>
