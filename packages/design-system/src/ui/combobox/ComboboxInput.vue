<script setup>
import { computed } from "vue";
import { reactiveOmit } from "@vueuse/core";
import { ChevronDown } from "lucide-vue-next";
import { ComboboxInput as ComboboxInputPrimitive, useForwardProps } from "reka-ui";
import { useI18n } from "vue-i18n";
import { cn } from "@monjizeen/design-system/lib/utils";

defineOptions({
  inheritAttrs: false,
});

const props = defineProps({
  disabled: { type: Boolean, required: false },
  displayValue: { type: Function, required: false },
  autoFocus: { type: Boolean, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  class: { type: null, required: false },
  variant: {
    type: String,
    default: "default",
    validator: (v) => ["default", "tableCell"].includes(v),
  },
  /** When false, hides the trailing chevron (e.g. search field inside popover). */
  showChevron: { type: Boolean, default: true },
});

const delegatedProps = reactiveOmit(props, "class", "variant");
const forwardedProps = useForwardProps(delegatedProps);
const { t } = useI18n();
const defaultPlaceholder = computed(() => t("placeholderChooseOption"));

const endPadding = computed(() => (props.showChevron ? "pe-9" : "pe-3"));

const comboboxInputClass = computed(() =>
  props.variant === "tableCell"
    ? cn(
        "file:text-foreground selection:bg-primary selection:text-primary-foreground flex h-9 w-full min-w-0 rounded-md border border-transparent bg-transparent px-3 py-1 text-start text-base text-foreground shadow-none outline-none transition-[color,box-shadow,border-color,background-color] file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        endPadding.value,
        props.class,
      )
    : cn(
        "border-input file:text-foreground selection:bg-primary selection:text-primary-foreground flex h-9 w-full min-w-0 rounded-md border bg-card px-3 py-1 text-start text-base text-foreground shadow-xs transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
        "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
        endPadding.value,
        props.class,
      ),
);
</script>

<template>
  <div class="relative w-full" data-slot="combobox-input-control">
    <ComboboxInputPrimitive
      data-slot="combobox-input"
      v-bind="{ ...$attrs, ...forwardedProps }"
      :placeholder="$attrs.placeholder ?? defaultPlaceholder"
      :data-table-cell-inline="variant === 'tableCell' ? '' : undefined"
      :class="comboboxInputClass"
    />
    <ChevronDown
      v-if="showChevron"
      class="pointer-events-none absolute top-1/2 end-3 size-4 -translate-y-1/2 opacity-50"
      aria-hidden="true"
    />
  </div>
</template>
