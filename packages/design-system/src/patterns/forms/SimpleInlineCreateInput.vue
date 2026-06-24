<script setup>
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import InlineInputGroup from '@monjizeen/design-system/patterns/forms/InlineInputGroup.vue'
import InlineInputActionsBar from '@monjizeen/design-system/patterns/forms/InlineInputActionsBar.vue'
import ValidationFieldHint from '@monjizeen/design-system/patterns/forms/ValidationFieldHint.vue'
import { Button } from '@monjizeen/design-system/ui/button'
import { Textarea } from '@monjizeen/design-system/ui/textarea'
import { ArrowUp } from 'lucide-vue-next'

const { t } = useI18n()

const props = defineProps({
  modelValue: { type: String, default: '' },
  placeholder: { type: String, default: '' },
  disabled: { type: Boolean, default: false },
  busy: { type: Boolean, default: false },
  errorMessage: { type: String, default: '' },
  submitDisabled: { type: Boolean, default: false },
  submitAriaLabel: { type: String, default: '' },
  inputId: { type: String, default: '' },
  inputAriaLabel: { type: String, default: '' },
})

const emit = defineEmits(['update:modelValue', 'submit', 'keydown'])

const textModel = computed({
  get: () => props.modelValue,
  set: (v) => emit('update:modelValue', v),
})

const invalidRingClass =
  'ring-[3px] ring-destructive/20 dark:ring-destructive/40'

const textareaClass =
  'field-sizing-content max-h-32 min-h-8 min-w-0 w-full resize-none rounded-none border-0 bg-transparent px-2 py-1.5 text-base leading-snug shadow-none focus-visible:ring-0 dark:bg-transparent md:text-sm'

const submitLabel = computed(() => props.submitAriaLabel || t('actionCreate'))
</script>

<template>
  <div class="w-full min-w-0">
    <InlineInputGroup
      :disabled="disabled"
      :invalid="Boolean(errorMessage)"
      :text="modelValue"
    >
      <ValidationFieldHint :error="errorMessage || null">
        <Textarea
          :id="inputId || undefined"
          v-model="textModel"
          data-slot="input-group-control"
          rows="1"
          :disabled="disabled || busy"
          :placeholder="placeholder"
          :aria-label="inputAriaLabel || placeholder"
          :aria-invalid="errorMessage ? 'true' : undefined"
          :class="textareaClass"
          @keydown="emit('keydown', $event)"
        />
      </ValidationFieldHint>

      <template #end>
        <InlineInputActionsBar
          v-if="$slots.end"
          :disabled="disabled || busy"
        >
          <slot name="end" />
        </InlineInputActionsBar>

        <ValidationFieldHint :error="errorMessage || null">
          <Button
            type="button"
            size="icon-sm"
            class="size-8 shrink-0 rounded-full bg-primary-foreground text-foreground hover:bg-primary-foreground/90"
            :class="errorMessage && invalidRingClass"
            :disabled="disabled || busy || submitDisabled || !modelValue.trim()"
            :aria-label="submitLabel"
            :aria-invalid="errorMessage ? 'true' : undefined"
            @click="emit('submit')"
          >
            <ArrowUp class="size-4" aria-hidden="true" />
          </Button>
        </ValidationFieldHint>
      </template>
    </InlineInputGroup>
  </div>
</template>
