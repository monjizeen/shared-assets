<script setup>
import { computed } from 'vue'
import { cn } from '@monjizeen/design-system/lib/utils'

const props = defineProps({
  label: { type: String, default: '' },
  required: { type: Boolean, default: false },
  error: { type: String, default: null },
  htmlFor: { type: String, default: null },
  /** When true, label sits inside the field and floats on focus / when filled (text inputs only). */
  floatLabel: { type: Boolean, default: true },
})

const useFloating = computed(() => props.floatLabel && !!props.label && !!props.htmlFor)

const errorClass = computed(() => (props.error ? 'border-destructive' : ''))

const inputClass = computed(() =>
  cn(
    useFloating.value &&
      'min-h-11 h-11 pt-3.5 pb-1.5 placeholder:text-transparent',
    errorClass.value,
  ),
)

/** Uses group + :focus-within / :has() so labels work when the control is wrapped (e.g. combobox trigger). */
const floatingLabelClass = cn(
  'pointer-events-none absolute start-3 top-1/2 z-10 -translate-y-1/2 text-sm text-muted-foreground transition-all duration-300 ease-[cubic-bezier(0.34,1.56,0.64,1)]',
  'group-focus-within:top-1.5 group-focus-within:translate-y-0 group-focus-within:text-[10px] group-focus-within:leading-none group-focus-within:text-foreground',
  'group-has-[input:not(:placeholder-shown)]:top-1.5 group-has-[input:not(:placeholder-shown)]:translate-y-0 group-has-[input:not(:placeholder-shown)]:text-[10px] group-has-[input:not(:placeholder-shown)]:leading-none group-has-[input:not(:placeholder-shown)]:text-foreground',
  'group-has-[input:disabled]:opacity-50',
)
</script>

<template>
  <div class="grid gap-2">
    <template v-if="useFloating">
      <div class="group relative">
        <slot :has-error="!!error" :error-class="errorClass" :input-class="inputClass" />
        <label :for="htmlFor" :class="floatingLabelClass">
          <span v-html="label" /> <span v-if="required" class="text-destructive">*</span>
        </label>
      </div>
      <slot name="hint" />
    </template>
    <template v-else>
      <label
        v-if="label"
        :for="htmlFor"
        class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        <span v-html="label" /> <span v-if="required" class="text-destructive">*</span>
      </label>
      <slot :has-error="!!error" :error-class="errorClass" :input-class="inputClass" />
      <slot name="hint" />
    </template>
    <p v-if="error" class="text-xs text-destructive">{{ error }}</p>
  </div>
</template>
