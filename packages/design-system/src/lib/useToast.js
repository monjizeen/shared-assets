import { ref } from 'vue'

const toasts = ref([])

let nextId = 0

function addToast(message, type = 'info', duration = 4000) {
  const id = nextId++
  const toast = { id, message, type }

  toasts.value.push(toast)

  if (duration > 0) {
    setTimeout(() => {
      removeToast(id)
    }, duration)
  }

  return id
}

function removeToast(id) {
  const index = toasts.value.findIndex((t) => t.id === id)
  if (index !== -1) {
    toasts.value.splice(index, 1)
  }
}

function error(message, duration) {
  return addToast(message, 'error', duration)
}

function success(message, duration) {
  return addToast(message, 'success', duration)
}

function info(message, duration) {
  return addToast(message, 'info', duration)
}

function warning(message, duration) {
  return addToast(message, 'warning', duration)
}

export function useToast() {
  return {
    toasts,
    addToast,
    removeToast,
    error,
    success,
    info,
    warning,
  }
}
