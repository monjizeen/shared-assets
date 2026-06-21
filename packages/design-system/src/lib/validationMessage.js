/**
 * Normalize Laravel / Inertia validation errors for display in FormField.
 * @param {unknown} err
 * @returns {string|null}
 */
export function validationMessage(err) {
  if (err == null || err === '') return null
  if (Array.isArray(err)) return err.length ? String(err[0]) : null
  return String(err)
}
