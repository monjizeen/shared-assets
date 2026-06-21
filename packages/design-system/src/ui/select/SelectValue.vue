<script setup>
import { computed } from "vue";
import { useI18n } from "vue-i18n";
import { SelectValue } from "reka-ui";

const props = defineProps({
  placeholder: { type: String, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
});

const { t } = useI18n();

const resolvedPlaceholder = computed(() => props.placeholder ?? t("placeholderChooseOption"));
</script>

<template>
  <SelectValue
    data-slot="select-value"
    :as-child="props.asChild"
    :as="props.as"
    :placeholder="resolvedPlaceholder"
  >
    <slot />
  </SelectValue>
</template>
