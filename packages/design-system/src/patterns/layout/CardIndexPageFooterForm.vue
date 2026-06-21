<script setup>
defineProps({
  /** Extra classes on the `<form>` element. */
  formClass: { type: String, default: '' },
})

defineEmits(['submit'])
</script>

<template>
  <form
    class="flex flex-wrap items-center gap-2"
    :class="formClass"
    @submit.prevent="$emit('submit')"
  >
    <slot />
  </form>
</template>
