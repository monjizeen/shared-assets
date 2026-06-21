<script setup>
import { useToast } from '@monjizeen/design-system/lib/useToast'
import { X, AlertCircle, CheckCircle, Info, AlertTriangle } from 'lucide-vue-next'

const { toasts, removeToast } = useToast()

function getIconComponent(type) {
  switch (type) {
    case 'error':
      return AlertCircle
    case 'success':
      return CheckCircle
    case 'warning':
      return AlertTriangle
    default:
      return Info
  }
}

function getToastClass(type) {
  const baseClass = 'flex items-start gap-3 rounded-lg border p-4 text-sm shadow-sm'
  switch (type) {
    case 'error':
      return `${baseClass} border-destructive/50 bg-destructive/5 text-destructive`
    case 'success':
      return `${baseClass} border-emerald-500/50 bg-emerald-500/5 text-emerald-700 dark:text-emerald-400`
    case 'warning':
      return `${baseClass} border-amber-500/50 bg-amber-500/5 text-amber-700 dark:text-amber-400`
    default:
      return `${baseClass} border-blue-500/50 bg-blue-500/5 text-blue-700 dark:text-blue-400`
  }
}
</script>

<template>
  <div class="fixed bottom-4 end-4 z-50 flex max-w-sm flex-col gap-2">
    <transition-group name="toast" tag="div" class="flex flex-col gap-2">
      <div
        v-for="toast in toasts"
        :key="toast.id"
        :class="getToastClass(toast.type)"
      >
        <component
          :is="getIconComponent(toast.type)"
          class="mt-0.5 h-5 w-5 shrink-0"
          aria-hidden="true"
        />
        <div class="flex-1">
          {{ toast.message }}
        </div>
        <button
          type="button"
          class="ms-2 shrink-0 rounded hover:opacity-70 focus:outline-none focus:ring-2 focus:ring-offset-2"
          :aria-label="`Close notification`"
          @click="removeToast(toast.id)"
        >
          <X class="h-4 w-4" />
        </button>
      </div>
    </transition-group>
  </div>
</template>

<style scoped>
.toast-enter-active,
.toast-leave-active {
  transition: all 0.3s ease;
}

.toast-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.toast-leave-to {
  opacity: 0;
  transform: translateX(20px);
}
</style>
