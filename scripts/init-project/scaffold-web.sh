#!/usr/bin/env bash
# Scaffold a new monjizeen web app from templates/web-app (not kawader).
# Usage: scaffold-web.sh <project> [monorepo-root] [open|closed]

set -euo pipefail

PROJECT="${1:?project name required}"
MONO_ROOT="${2:-${HOME}/Documents/work/projects/monjizeen}"
AUTH_MODEL="${3:-closed}"
WORKSPACE="${MONO_ROOT}/${PROJECT}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/../../templates/web-app"
SHARED_ASSETS="$(cd "${SCRIPT_DIR}/../.." && pwd)"

if [[ "${AUTH_MODEL}" != "open" && "${AUTH_MODEL}" != "closed" ]]; then
  echo "error: auth model must be 'open' or 'closed'" >&2
  exit 1
fi

if [[ ! -d "${TEMPLATE}" ]]; then
  echo "error: missing ${TEMPLATE} — run build-web-app-template.sh first" >&2
  exit 1
fi

if [[ -d "${WORKSPACE}" ]]; then
  echo "error: workspace already exists: ${WORKSPACE}" >&2
  exit 1
fi

echo "scaffold-web: rsync template → ${WORKSPACE}"
rsync -a \
  --exclude 'database/database.sqlite' \
  --exclude 'node_modules' \
  --exclude 'vendor' \
  --exclude '.DS_Store' \
  --exclude '._*' \
  "${TEMPLATE}/" "${WORKSPACE}/"

cd "${WORKSPACE}"
rm -f database/database.sqlite

echo "scaffold-web: customize metadata for ${PROJECT}"
node -e "
const fs = require('fs');
const title = '${PROJECT}'.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
const pkgPath = 'package.json';
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
pkg.name = '${PROJECT}';
fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 4) + '\n');
const composerPath = 'composer.json';
const composer = JSON.parse(fs.readFileSync(composerPath, 'utf8'));
composer.name = 'monjizeen/${PROJECT}';
composer.description = title;
fs.writeFileSync(composerPath, JSON.stringify(composer, null, 2) + '\n');
let envEx = fs.readFileSync('.env.example', 'utf8');
envEx = envEx.replace(/^APP_NAME=.*/m, 'APP_NAME=\"' + title + '\"');
if (/^PLATFORM_AUTH_MODEL=/m.test(envEx)) {
  envEx = envEx.replace(/^PLATFORM_AUTH_MODEL=.*/m, 'PLATFORM_AUTH_MODEL=${AUTH_MODEL}');
} else {
  envEx += '\nPLATFORM_AUTH_MODEL=${AUTH_MODEL}\n';
}
fs.writeFileSync('.env.example', envEx);
"

echo "scaffold-web: install dependencies"
composer install --no-interaction
cp .env.example .env
php artisan key:generate --no-interaction
touch database/database.sqlite
php artisan migrate --force --no-interaction
npm install
npm run build

ENJAZ="${MONO_ROOT}/enjaz"
bash "${ENJAZ}/packages/design-system/scripts/install-cursor-rules.sh" "${WORKSPACE}"
cp "${ENJAZ}/packages/design-system/docs/BRIEF.template.md" "${WORKSPACE}/BRIEF.md"

php artisan test || echo "scaffold-web: warn — tests failed (review before push)"

find . \( -name '.DS_Store' -o -name '._*' -o -name 'Thumbs.db' -o -name 'Desktop.ini' \) -delete 2>/dev/null || true

echo "scaffold-web: done ${WORKSPACE}"
