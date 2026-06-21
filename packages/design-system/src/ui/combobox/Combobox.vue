<script setup>
import { ComboboxRoot, useForwardPropsEmits } from "reka-ui";

const props = defineProps({
  modelValue: { type: null, required: false },
  defaultValue: { type: null, required: false },
  open: { type: Boolean, required: false },
  defaultOpen: { type: Boolean, required: false },
  disabled: { type: Boolean, required: false },
  multiple: { type: Boolean, required: false },
  dir: { type: String, required: false },
  name: { type: String, required: false },
  required: { type: Boolean, required: false },
  by: { type: [String, Function], required: false },
  openOnFocus: { type: Boolean, required: false, default: true },
  openOnClick: { type: Boolean, required: false, default: true },
  ignoreFilter: { type: Boolean, required: false },
  resetSearchTermOnBlur: { type: Boolean, required: false },
  resetSearchTermOnSelect: { type: Boolean, required: false },
  resetModelValueOnClear: { type: Boolean, required: false },
  highlightOnHover: { type: Boolean, required: false },
});

const emits = defineEmits(["update:modelValue", "update:open", "highlight"]);

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <ComboboxRoot data-slot="combobox" v-bind="forwarded">
    <slot />
  </ComboboxRoot>
</template>
