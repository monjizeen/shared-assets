<script setup>
import ValidationFieldHint from '@monjizeen/design-system/patterns/forms/ValidationFieldHint.vue'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
  DropdownMenuTrigger,
} from '@monjizeen/design-system/ui/dropdown-menu'

defineOptions({ name: 'InlineInputAction' })

const props = defineProps({
  label: { type: String, required: true },
  hasValue: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  error: { type: String, default: '' },
  /** `inline` = icon trigger in the pill; `overflow` = row in More menu with submenu. */
  mode: {
    type: String,
    default: 'inline',
    validator: (v) => ['inline', 'overflow'].includes(v),
  },
  menuOpen: { type: Boolean, default: undefined },
  contentClass: { type: String, default: '' },
  contentAlign: { type: String, default: 'start' },
  contentSide: { type: String, default: 'top' },
})

const emit = defineEmits(['update:menuOpen'])

function onMenuOpenChange(open) {
  emit('update:menuOpen', open)
}
</script>

<template>
  <ValidationFieldHint :error="error || null">
    <DropdownMenu
      v-if="mode === 'inline'"
      :open="menuOpen"
      :modal="false"
      @update:open="onMenuOpenChange"
    >
      <DropdownMenuTrigger as-child>
        <slot name="trigger" />
      </DropdownMenuTrigger>
      <DropdownMenuContent
        :side="contentSide"
        :align="contentAlign"
        :class="contentClass"
        @close-auto-focus.prevent
      >
        <slot name="panel" />
      </DropdownMenuContent>
    </DropdownMenu>

    <DropdownMenuSub v-else>
      <DropdownMenuSubTrigger class="gap-2">
        <slot name="menu-icon" />
        <span class="min-w-0 truncate">{{ label }}</span>
        <span
          v-if="hasValue"
          class="ms-auto size-1.5 shrink-0 rounded-full bg-primary"
          aria-hidden="true"
        />
      </DropdownMenuSubTrigger>
      <DropdownMenuSubContent :class="contentClass">
        <slot name="panel" />
      </DropdownMenuSubContent>
    </DropdownMenuSub>
  </ValidationFieldHint>
</template>
