<script setup>
import { computed } from "vue";
import { useVModel } from "@vueuse/core";
import { cn } from "@monjizeen/design-system/lib/utils";

defineOptions({
  inheritAttrs: false,
});

const props = defineProps({
  defaultValue: { type: [String, Number], required: false },
  modelValue: { type: [String, Number], required: false },
  class: { type: null, required: false },
  /**
   * `tableCell`: borderless in table body until row hover / focus (see `app.css` + `data-table-cell-inline`).
   * Omit on `.table-add-row` so the +Add row keeps normal field chrome.
   */
  variant: {
    type: String,
    default: "default",
    validator: (v) => ["default", "tableCell"].includes(v),
  },
});

const emits = defineEmits(["update:modelValue"]);

const modelValue = useVModel(props, "modelValue", emits, {
  passive: true,
  defaultValue: props.defaultValue,
});

const inputClass = computed(() =>
  props.variant === "tableCell"
    ? cn(
        "h-9 w-full min-w-0 rounded-md border border-transparent bg-transparent px-3 py-1 text-start text-base text-foreground shadow-none outline-none transition-[color,box-shadow,border-color,background-color] md:text-sm [&[type=search]]:appearance-none",
        "selection:bg-primary selection:text-primary-foreground",
        "file:me-3 file:inline-flex file:h-7 file:shrink-0 file:items-center file:justify-center file:rounded-md file:border file:border-input file:bg-background file:px-3 file:text-sm file:font-medium file:text-foreground file:shadow-none file:transition-colors file:cursor-pointer file:hover:bg-accent file:hover:text-accent-foreground dark:file:bg-input/30 dark:file:border-input dark:file:hover:bg-input/50",
        "disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50",
        props.class,
      )
    : cn(
        "border-input h-9 w-full min-w-0 rounded-md border bg-card px-3 py-1 text-start text-base text-foreground shadow-xs transition-[color,box-shadow] outline-none [&[type=search]]:appearance-none file:me-3 file:inline-flex file:h-7 file:shrink-0 file:items-center file:justify-center file:rounded-md file:border file:border-input file:bg-background file:px-3 file:text-sm file:font-medium file:text-foreground file:shadow-xs file:transition-colors file:cursor-pointer file:hover:bg-accent file:hover:text-accent-foreground dark:file:bg-input/30 dark:file:border-input dark:file:hover:bg-input/50 selection:bg-primary selection:text-primary-foreground disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
        "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
        props.class,
      ),
);
</script>

<template>
  <input
    v-model="modelValue"
    v-bind="$attrs"
    data-slot="input"
    :data-table-cell-inline="variant === 'tableCell' ? '' : undefined"
    :class="inputClass"
  />
</template>
