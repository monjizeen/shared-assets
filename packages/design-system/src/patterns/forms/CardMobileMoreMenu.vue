<script setup>
import { Button } from '@monjizeen/design-system/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from '@monjizeen/design-system/ui/dropdown-menu'
import { MoreHorizontal } from 'lucide-vue-next'
import { useI18n } from 'vue-i18n'

defineProps({
  /** When false, the default slot renders directly (single actionable option). */
  useMenu: { type: Boolean, default: true },
  disabled: { type: Boolean, default: false },
  contentClass: { type: String, default: 'w-52' },
  triggerClass: { type: String, default: 'h-8 w-8 shrink-0 text-muted-foreground' },
})

const { t } = useI18n()
</script>

<template>
  <template v-if="useMenu">
    <DropdownMenu :modal="false">
      <DropdownMenuTrigger as-child>
        <Button
          type="button"
          variant="ghost"
          size="icon"
          :class="triggerClass"
          :disabled="disabled"
          :aria-label="t('navMore')"
        >
          <MoreHorizontal class="size-4" aria-hidden="true" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" :class="contentClass">
        <slot />
      </DropdownMenuContent>
    </DropdownMenu>
  </template>
  <div v-else class="flex shrink-0 items-center">
    <slot />
  </div>
</template>
