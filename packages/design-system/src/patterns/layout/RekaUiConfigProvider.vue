<script setup>
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { ConfigProvider } from 'reka-ui'

const { locale } = useI18n()

const dir = computed(() => (locale.value === 'ar' ? 'rtl' : 'ltr'))
</script>

<template>
  <ConfigProvider :dir="dir">
    <slot />
  </ConfigProvider>
</template>
