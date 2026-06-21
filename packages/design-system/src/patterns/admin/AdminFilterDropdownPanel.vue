<script setup>
import { useI18n } from 'vue-i18n'
import { DropdownMenuContent } from '@monjizeen/design-system/ui/dropdown-menu'

defineProps({
  align: { type: String, default: 'start' },
})

const { t } = useI18n()
</script>

<template>
  <DropdownMenuContent :align="align" class="w-max max-w-[92vw] p-3">
    <p class="mb-2 text-sm font-medium">
      {{ t('dialogFilters') }}
    </p>
    <div class="flex flex-col items-stretch gap-3">
      <slot />
    </div>
  </DropdownMenuContent>
</template>
