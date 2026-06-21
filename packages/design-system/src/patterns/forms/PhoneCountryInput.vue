<script setup>
import { ref, computed } from 'vue'
import { onClickOutside } from '@vueuse/core'
import { filterCountries, findCountryByCode } from '@monjizeen/design-system/lib/countryCodes.js'
import { Input } from '@monjizeen/design-system/ui/input'
import { cn } from '@monjizeen/design-system/lib/utils'

const props = defineProps({
  modelValue: { type: String, default: '' },
  /** Optional class for the wrapper (e.g. border-destructive) */
  inputClass: { type: null, default: null },
})

const emit = defineEmits(['update:modelValue'])

const open = ref(false)
const query = ref('')
const containerRef = ref(null)
const inputRef = ref(null)

onClickOutside(containerRef, () => { open.value = false })

const selectedCountry = computed(() => findCountryByCode(props.modelValue))

const displayValue = computed(() => {
  const c = selectedCountry.value
  if (c) return `${c.flag} +${c.code}`
  if (props.modelValue) return `+${props.modelValue}`
  return ''
})

const suggestions = computed(() => {
  const q = query.value.trim()
  const filtered = filterCountries(q)
  if (!q) return filtered
  const digits = q.replace(/\D/g, '')
  if (digits.length >= 1 && digits.length <= 4 && !filtered.some((c) => c.code === digits)) {
    return [{ code: digits, name: `Use +${digits}`, flag: '', custom: true }, ...filtered]
  }
  return filtered
})

function onFocus() {
  open.value = true
  query.value = ''
}

function onInput(e) {
  const v = (e.target?.value ?? '').trim()
  open.value = true
  query.value = v
}

function select(code) {
  emit('update:modelValue', code)
  open.value = false
  query.value = ''
  inputRef.value?.blur()
}

function onKeydown(e) {
  if (e.key === 'Escape') {
    open.value = false
    query.value = ''
  }
}
</script>

<template>
  <div ref="containerRef" class="relative w-[140px] shrink-0" dir="ltr">
    <Input
      ref="inputRef"
      :model-value="open && query !== '' ? query : displayValue"
      type="text"
      inputmode="tel"
      autocomplete="off"
      :class="cn('pe-8', inputClass)"
      @focus="onFocus"
      @input="onInput"
      @keydown="onKeydown"
    />
    <div
      v-show="open && suggestions.length"
      class="absolute top-full start-0 z-50 mt-1 max-h-[240px] w-full overflow-auto rounded-md border border-border bg-popover py-1 text-popover-foreground shadow-md"
      role="listbox"
    >
      <button
        v-for="opt in suggestions"
        :key="opt.code + (opt.custom ? '-custom' : '')"
        type="button"
        role="option"
        class="flex w-full cursor-pointer items-center gap-2 px-3 py-2 text-start text-sm hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none"
        @click="select(opt.code)"
      >
        <span v-if="opt.flag" class="shrink-0 text-base leading-none">{{ opt.flag }}</span>
        <span class="min-w-0 truncate">{{ opt.flag ? `+${opt.code} ${opt.name}` : opt.name }}</span>
      </button>
    </div>
  </div>
</template>
