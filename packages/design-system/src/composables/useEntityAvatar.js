import { computed, toValue } from 'vue'

/** Photo URL from entity objects (supports common avatar field names). */
export function useEntityPhotoSrc(entity, { keys = ['photo_url', 'avatar_url'] } = {}) {
  return computed(() => {
    const u = toValue(entity)
    if (!u || typeof u !== 'object') return ''
    for (const key of keys) {
      const raw = u[key]
      if (typeof raw === 'string' && raw.trim() !== '') return raw.trim()
    }
    return ''
  })
}

/** Two-letter initials from a display name. */
export function useAvatarInitials(displayName) {
  return computed(() => {
    const n = String(toValue(displayName) ?? '').trim()
    if (!n) return '?'
    const parts = n.split(/\s+/).filter(Boolean)
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase().slice(0, 2)
    }
    return n.slice(0, 2).toUpperCase()
  })
}
