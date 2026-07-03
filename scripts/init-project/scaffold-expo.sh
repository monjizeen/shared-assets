#!/usr/bin/env bash
# Scaffold a new monjizeen-dev Expo (React Native) app.
# Usage: scaffold-expo.sh <project> [monorepo-root]

set -euo pipefail

PROJECT="${1:?project name required}"
MONO_ROOT="${2:-${HOME}/Documents/work/projects/monjizeen-dev}"
WORKSPACE="${MONO_ROOT}/${PROJECT}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/../../templates/expo-app"

if [[ -d "${WORKSPACE}" ]]; then
  echo "error: workspace already exists: ${WORKSPACE}" >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "error: npx required" >&2
  exit 1
fi

echo "scaffold-expo: create Expo app in ${WORKSPACE}"
if [[ -f "${TEMPLATE}/package.json" ]]; then
  rsync -a --exclude 'node_modules' "${TEMPLATE}/" "${WORKSPACE}/"
  cd "${WORKSPACE}"
  npm install
else
  mkdir -p "${MONO_ROOT}"
  cd "${MONO_ROOT}"
  npx create-expo-app@latest "${PROJECT}" --template blank-typescript --yes
  cd "${WORKSPACE}"
  npm install lucide-react-native react-native-svg
fi

# Org conventions overlay
mkdir -p "${WORKSPACE}/docs"
cat > "${WORKSPACE}/docs/ARCHITECTURE.md" <<MD
# ${PROJECT} — mobile architecture

## Stack

- Expo (React Native) + TypeScript
- **Icons:** Lucide (\`lucide-react-native\`)
- API backend: separate web service (Laravel on mnjz.in) when needed

## Native features

Use Expo modules (camera, notifications, secure store, etc.) via \`npx expo install <package>\`.

## Design

No shadcn on mobile — use React Native primitives + org spacing/color tokens in \`constants/theme.ts\`.
Lucide for all icons.
MD

if [[ ! -f "${WORKSPACE}/constants/theme.ts" ]]; then
  mkdir -p "${WORKSPACE}/constants"
  cat > "${WORKSPACE}/constants/theme.ts" <<'TS'
export const colors = {
  background: '#ffffff',
  foreground: '#18181b',
  primary: '#18181b',
  primaryForeground: '#fafafa',
  muted: '#f4f4f5',
  mutedForeground: '#71717a',
  border: '#e4e4e7',
  destructive: '#dc2626',
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
} as const;
TS
fi

cat > "${WORKSPACE}/README.md" <<MD
# ${PROJECT}

Expo mobile app (monjizeen-dev org scaffold).

## Setup

\`\`\`bash
npm install
npx expo start
\`\`\`

## Icons

Import from \`lucide-react-native\` only.

## Backend

Pair with a Laravel API project on \`${PROJECT}-staging.mnjz.in\` when the product needs a web backend.
MD

find "${WORKSPACE}" \( -name '.DS_Store' -o -name '._*' \) -delete 2>/dev/null || true

echo "scaffold-expo: done ${WORKSPACE}"
