<script setup>
import { cn } from '@monjizeen/design-system/lib/utils'

const props = defineProps({
  class: { type: null, required: false },
})
</script>

<template>
  <div
    data-slot="button-group"
    :class="cn(
      'inline-flex w-fit items-center overflow-hidden rounded-md border border-input shadow-xs '
      + '[&>[data-slot=button]]:rounded-none '
      + '[&>[data-slot=button]]:min-h-8 '
      + '[&>[data-slot=button]]:h-full '
      + '[&>[data-slot=button]]:!border-0 '
      + '[&>[data-slot=button]]:shadow-none '
      + '[&>[data-slot=button]]:focus-visible:z-10 '
      + '[&>[data-slot=button]]:active:bg-accent/80 '
      + '[&>[data-slot=dropdown-menu-trigger]]:rounded-none '
      + '[&>[data-slot=dropdown-menu-trigger]]:min-h-8 '
      + '[&>[data-slot=dropdown-menu-trigger]]:h-full '
      + '[&>[data-slot=dropdown-menu-trigger]]:!border-0 '
      + '[&>[data-slot=dropdown-menu-trigger]]:shadow-none '
      + '[&>[data-slot=dropdown-menu-trigger]]:focus-visible:z-10 '
      + '[&>[data-slot=dropdown-menu-trigger]]:active:bg-accent/80 '
      + '[&>*]:relative '
      + '[&>*:not(:last-child)]:after:absolute '
      + '[&>*:not(:last-child)]:after:inset-y-2 '
      + '[&>*:not(:last-child)]:after:end-0 '
      + '[&>*:not(:last-child)]:after:w-px '
      + '[&>*:not(:last-child)]:after:bg-border/80 '
      + '[&>*:not(:last-child)]:after:content-[\'\']',
      props.class
    )"
  >
    <slot />
  </div>
</template>
