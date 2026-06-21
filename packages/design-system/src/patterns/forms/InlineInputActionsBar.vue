<script setup>
import { Fragment, cloneVNode, computed, isVNode, useSlots } from 'vue'
import CardMobileMoreMenu from '@monjizeen/design-system/patterns/forms/CardMobileMoreMenu.vue'
import { inlineInputActionsVisibleCount } from '@monjizeen/design-system/lib/inlineInputActions.js'

defineOptions({ name: 'InlineInputActionsBar' })

const props = defineProps({
  disabled: { type: Boolean, default: false },
  contentClass: { type: String, default: 'w-56' },
})

const slots = useSlots()

function isInlineInputAction(vnode) {
  const type = vnode?.type
  if (!type || typeof type !== 'object') return false
  return type.__name === 'InlineInputAction' || type.name === 'InlineInputAction'
}

function collectActionVnodes(vnodes) {
  const out = []
  for (const node of vnodes ?? []) {
    if (!isVNode(node)) continue
    if (isInlineInputAction(node)) {
      out.push(node)
      continue
    }
    if (node.type === Fragment) {
      out.push(...collectActionVnodes(node.children))
      continue
    }
    if (typeof node.type === 'object' && typeof node.children === 'object' && node.children?.default) {
      out.push(...collectActionVnodes(node.children.default()))
    }
  }
  return out
}

const actionVnodes = computed(() => collectActionVnodes(slots.default?.() ?? []))
const actionCount = computed(() => actionVnodes.value.length)
const visibleCount = computed(() => inlineInputActionsVisibleCount(actionCount.value))
const useOverflow = computed(() => visibleCount.value < actionCount.value)

const inlineActions = computed(() =>
  actionVnodes.value.slice(0, visibleCount.value).map((vnode) => cloneVNode(vnode, { mode: 'inline' })),
)

const overflowActions = computed(() =>
  actionVnodes.value.slice(visibleCount.value).map((vnode) => cloneVNode(vnode, { mode: 'overflow' })),
)
</script>

<template>
  <template v-for="(vnode, index) in inlineActions" :key="`inline-action-${index}`">
    <component :is="vnode" />
  </template>

  <CardMobileMoreMenu
    v-if="useOverflow"
    :disabled="disabled"
    :content-class="contentClass"
    trigger-class="relative size-8 shrink-0 rounded-full text-muted-foreground hover:bg-muted hover:text-foreground"
  >
    <template v-for="(vnode, index) in overflowActions" :key="`overflow-action-${index}`">
      <component :is="vnode" />
    </template>
  </CardMobileMoreMenu>
</template>
