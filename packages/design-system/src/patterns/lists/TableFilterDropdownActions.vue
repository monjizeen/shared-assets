<script setup>
import { useI18n } from 'vue-i18n'
import { Button } from '@monjizeen/design-system/ui/button'

const { t } = useI18n()
const emit = defineEmits(['filter', 'reset'])
</script>

<template>
  <div class="border-border mt-1 flex w-full min-w-[200px] flex-row gap-2 border-t pt-3">
    <Button variant="default" size="sm" class="min-w-0 flex-1" type="button" @click="emit('filter')">
      {{ t('actionFilter') }}
    </Button>
    <Button variant="outline" size="sm" class="min-w-0 flex-1" type="button" @click="emit('reset')">
      {{ t('actionReset') }}
    </Button>
  </div>
</template>
