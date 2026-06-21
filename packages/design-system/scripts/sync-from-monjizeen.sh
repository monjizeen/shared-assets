#!/usr/bin/env bash
# Sync design-system package from monjizeen reference app.
# Maintainer script — run after monjizeen DS changes stabilize.
# Usage: sync-from-monjizeen.sh [monorepo-root]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MONO_ROOT="${1:-$(cd "${PKG_ROOT}/../../.." && pwd)}"
MONJIZEEN="${MONO_ROOT}/monjizeen"
DS_SRC="${MONJIZEEN}/resources/js"
DS_CSS="${MONJIZEEN}/resources/css"

if [[ ! -d "${MONJIZEEN}" ]]; then
  echo "error: monjizeen not found at ${MONJIZEEN}" >&2
  exit 1
fi

echo "sync: clean package src (keep docs README package.json)"
rm -rf "${PKG_ROOT}/src"
mkdir -p "${PKG_ROOT}/src/ui" "${PKG_ROOT}/styles" "${PKG_ROOT}/assets/fonts"

echo "sync: ui primitives"
cp -R "${DS_SRC}/components/ui/." "${PKG_ROOT}/src/ui/"

echo "sync: patterns"
mkdir -p \
  "${PKG_ROOT}/src/patterns/navigation" \
  "${PKG_ROOT}/src/patterns/layout" \
  "${PKG_ROOT}/src/patterns/forms" \
  "${PKG_ROOT}/src/patterns/lists" \
  "${PKG_ROOT}/src/patterns/admin"

cp "${DS_SRC}/components/navigation/PageBreadcrumb.vue" "${PKG_ROOT}/src/patterns/navigation/"
cp "${DS_SRC}/components/navigation/NavDrawerContent.vue" "${PKG_ROOT}/src/patterns/navigation/"

for f in CardIndexPageLayout InputActionIndexPageLayout CardIndexPageFooterForm \
  ThemeTransitionAppShell ThemeTransitionOverlay RekaUiConfigProvider Toast; do
  cp "${DS_SRC}/components/${f}.vue" "${PKG_ROOT}/src/patterns/layout/"
done

for f in FormField ValidationFieldHint InlineFieldTooltip InlineInputGroup \
  InlineInputAction InlineInputActionsBar SimpleInlineCreateInput PhoneCountryInput \
  CardMobileMoreMenu ThemeToggle; do
  cp "${DS_SRC}/components/${f}.vue" "${PKG_ROOT}/src/patterns/forms/"
done

cp "${DS_SRC}/components/admin/AdminFilterDropdownPanel.vue" "${PKG_ROOT}/src/patterns/admin/"

for f in ListQuickRow ListQuickRowIcon ListQuickRowMeta ListCollapsibleSection; do
  cp "${DS_SRC}/components/lists/${f}.vue" "${PKG_ROOT}/src/patterns/lists/"
done

for f in EmptyStatePanel TableFilterDropdownActions TableColumnResizeHandle; do
  cp "${DS_SRC}/components/${f}.vue" "${PKG_ROOT}/src/patterns/lists/"
done

echo "sync: composables"
mkdir -p "${PKG_ROOT}/src/composables"
for f in useTableHorizontalScrollAffordance useTableColumnWidths useInlineInputExpanded \
  useCollapsibleSections useVisualViewportKeyboard useEntityAvatar \
  useDashboardSectionPreview useFocusFirstFormFieldOnMount; do
  cp "${DS_SRC}/composables/${f}.js" "${PKG_ROOT}/src/composables/"
done

echo "sync: lib"
mkdir -p "${PKG_ROOT}/src/lib"
for f in utils focusFirstFormField useToast validationMessage inlineInputActions \
  quickCreateFocus textareaCaretCoordinates useTableSort useTableVisibleColumns \
  tablistArrowNavigation themeSunriseCanvas countryCodes; do
  cp "${DS_SRC}/lib/${f}.js" "${PKG_ROOT}/src/lib/"
done

echo "sync: store"
mkdir -p "${PKG_ROOT}/src/store"
cp "${DS_SRC}/store/theme.js" "${PKG_ROOT}/src/store/"

echo "sync: styles"
cp "${DS_CSS}/brand.css" "${PKG_ROOT}/styles/brand.css"
cp "${DS_CSS}/app-theme.css" "${PKG_ROOT}/styles/theme.css"

# Table + layout utilities from app.css (DS-relevant slice)
awk '/^\/\*$/,0' "${DS_CSS}/app.css" | sed -n '/Ghost actions column/,/^$/p' > "${PKG_ROOT}/styles/_utilities-slice.css" || true

# Build utilities.css from app.css lines 15-164 (table + bottom-nav utilities)
sed -n '15,164p' "${DS_CSS}/app.css" > "${PKG_ROOT}/styles/utilities.css"

cat > "${PKG_ROOT}/styles/index.css" <<'CSS'
@import "./brand.css";
@import "./theme.css";
@import "./utilities.css";
CSS

# Fonts (optional — copy if present)
if compgen -G "${MONJIZEEN}/public/SomarSans-"*.woff2 > /dev/null; then
  cp "${MONJIZEEN}"/public/SomarSans-*.woff2 "${PKG_ROOT}/assets/fonts/" 2>/dev/null || true
  # Fix font paths in theme.css for package layout
  sed -i '' 's|url("../../public/|url("../assets/fonts/|g' "${PKG_ROOT}/styles/theme.css" 2>/dev/null || \
    sed -i 's|url("../../public/|url("../assets/fonts/|g' "${PKG_ROOT}/styles/theme.css"
fi

echo "sync: rewrite @/ imports to package paths"
find "${PKG_ROOT}/src" -type f \( -name '*.vue' -o -name '*.js' \) -print0 | while IFS= read -r -d '' file; do
  sed -i '' \
    -e "s|@/components/ui/|@monjizeen/design-system/ui/|g" \
    -e "s|@/lib/|@monjizeen/design-system/lib/|g" \
    -e "s|@/composables/|@monjizeen/design-system/composables/|g" \
    -e "s|@/store/|@monjizeen/design-system/store/|g" \
    -e "s|@/components/navigation/|@monjizeen/design-system/patterns/navigation/|g" \
    -e "s|@/components/lists/|@monjizeen/design-system/patterns/lists/|g" \
    -e "s|@/components/admin/|@monjizeen/design-system/patterns/admin/|g" \
    -e "s|@/components/ValidationFieldHint.vue|@monjizeen/design-system/patterns/forms/ValidationFieldHint.vue|g" \
    -e "s|@/components/InlineFieldTooltip.vue|@monjizeen/design-system/patterns/forms/InlineFieldTooltip.vue|g" \
    -e "s|@/components/InlineInputGroup.vue|@monjizeen/design-system/patterns/forms/InlineInputGroup.vue|g" \
    -e "s|@/components/InlineInputAction.vue|@monjizeen/design-system/patterns/forms/InlineInputAction.vue|g" \
    -e "s|@/components/InlineInputActionsBar.vue|@monjizeen/design-system/patterns/forms/InlineInputActionsBar.vue|g" \
    -e "s|@/components/CardMobileMoreMenu.vue|@monjizeen/design-system/patterns/forms/CardMobileMoreMenu.vue|g" \
    -e "s|@/components/FormField.vue|@monjizeen/design-system/patterns/forms/FormField.vue|g" \
    -e "s|@/components/EmptyStatePanel.vue|@monjizeen/design-system/patterns/lists/EmptyStatePanel.vue|g" \
    -e "s|@/components/Toast.vue|@monjizeen/design-system/patterns/layout/Toast.vue|g" \
    "${file}" 2>/dev/null || \
  sed -i \
    -e "s|@/components/ui/|@monjizeen/design-system/ui/|g" \
    -e "s|@/lib/|@monjizeen/design-system/lib/|g" \
    -e "s|@/composables/|@monjizeen/design-system/composables/|g" \
    -e "s|@/store/|@monjizeen/design-system/store/|g" \
    -e "s|@/components/navigation/|@monjizeen/design-system/patterns/navigation/|g" \
    -e "s|@/components/lists/|@monjizeen/design-system/patterns/lists/|g" \
    -e "s|@/components/admin/|@monjizeen/design-system/patterns/admin/|g" \
    -e "s|@/components/ValidationFieldHint.vue|@monjizeen/design-system/patterns/forms/ValidationFieldHint.vue|g" \
    -e "s|@/components/InlineFieldTooltip.vue|@monjizeen/design-system/patterns/forms/InlineFieldTooltip.vue|g" \
    -e "s|@/components/InlineInputGroup.vue|@monjizeen/design-system/patterns/forms/InlineInputGroup.vue|g" \
    -e "s|@/components/InlineInputAction.vue|@monjizeen/design-system/patterns/forms/InlineInputAction.vue|g" \
    -e "s|@/components/InlineInputActionsBar.vue|@monjizeen/design-system/patterns/forms/InlineInputActionsBar.vue|g" \
    -e "s|@/components/CardMobileMoreMenu.vue|@monjizeen/design-system/patterns/forms/CardMobileMoreMenu.vue|g" \
    -e "s|@/components/FormField.vue|@monjizeen/design-system/patterns/forms/FormField.vue|g" \
    -e "s|@/components/EmptyStatePanel.vue|@monjizeen/design-system/patterns/lists/EmptyStatePanel.vue|g" \
    -e "s|@/components/Toast.vue|@monjizeen/design-system/patterns/layout/Toast.vue|g" \
    "${file}"
done

# Theme store: configurable storage key
sed -i '' "s/const STORAGE_KEY = 'monjizeen-theme'/const STORAGE_KEY = typeof import.meta !== 'undefined' \&\& import.meta.env?.VITE_DS_THEME_STORAGE_KEY || 'app-theme'/g" \
  "${PKG_ROOT}/src/store/theme.js" 2>/dev/null || \
sed -i "s/const STORAGE_KEY = 'monjizeen-theme'/const STORAGE_KEY = typeof import.meta !== 'undefined' \&\& import.meta.env?.VITE_DS_THEME_STORAGE_KEY || 'app-theme'/g" \
  "${PKG_ROOT}/src/store/theme.js"

echo "sync: generate src/index.js barrel"
cat > "${PKG_ROOT}/src/index.js" <<'JS'
/**
 * @monjizeen/design-system — org UI package.
 * Import subpaths directly for tree-shaking:
 *   import { Button } from '@monjizeen/design-system/ui/button'
 *   import '@monjizeen/design-system/styles'
 */
export { cn } from './lib/utils.js'
export { theme, initTheme } from './store/theme.js'
export { useToast, toast } from './lib/useToast.js'
JS

echo "sync: done — review git diff before commit"
