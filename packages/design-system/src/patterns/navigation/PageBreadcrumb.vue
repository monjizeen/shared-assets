<script setup>
import { Link } from '@inertiajs/vue3'
import { useI18n } from 'vue-i18n'
import { ChevronRight } from 'lucide-vue-next'
import { cn } from '@monjizeen/design-system/lib/utils'

const props = defineProps({
  /** @type {{ label: string, href?: string }[]} */
  items: {
    type: Array,
    required: true,
    validator: (items) => items.length > 0 && items.every((item) => item?.label),
  },
  class: { type: null, required: false },
})

const { t } = useI18n()

const BREADCRUMB_LABEL_MAX_LENGTH = 20

function displayLabel(label) {
  if (label.length <= BREADCRUMB_LABEL_MAX_LENGTH) {
    return label
  }

  return `${label.slice(0, BREADCRUMB_LABEL_MAX_LENGTH)}…`
}

function isLabelTruncated(label) {
  return label.length > BREADCRUMB_LABEL_MAX_LENGTH
}
</script>

<template>
  <nav
    :aria-label="t('ariaBreadcrumb')"
    :class="cn('min-w-0', props.class)"
    data-slot="page-breadcrumb"
  >
    <ol class="flex flex-wrap items-center gap-1.5 text-xs font-normal text-muted-foreground">
      <li
        v-for="(item, index) in items"
        :key="index"
        class="inline-flex min-w-0 max-w-full items-center gap-1.5"
      >
        <ChevronRight
          v-if="index > 0"
          class="size-3.5 shrink-0 opacity-60 rtl:rotate-180"
          aria-hidden="true"
        />
        <Link
          v-if="item.href && index < items.length - 1"
          :href="item.href"
          class="truncate font-normal hover:text-foreground hover:underline"
          :title="isLabelTruncated(item.label) ? item.label : undefined"
        >
          {{ displayLabel(item.label) }}
        </Link>
        <span
          v-else
          class="truncate font-normal text-foreground"
          :aria-current="index === items.length - 1 ? 'page' : undefined"
          :title="isLabelTruncated(item.label) ? item.label : undefined"
        >
          {{ displayLabel(item.label) }}
        </span>
      </li>
    </ol>
  </nav>
</template>
