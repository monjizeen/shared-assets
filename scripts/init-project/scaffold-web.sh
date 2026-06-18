#!/usr/bin/env bash
# Scaffold a new monjizeen-dev web app from templates/web-app (not kawader).
# Usage: scaffold-web.sh <project> [monorepo-root]

set -euo pipefail

PROJECT="${1:?project name required}"
MONO_ROOT="${2:-${HOME}/Documents/work/projects/monjizeen-dev}"
WORKSPACE="${MONO_ROOT}/${PROJECT}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/../../templates/web-app"
SHARED_ASSETS="$(cd "${SCRIPT_DIR}/../.." && pwd)"

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
composer.name = 'monjizeen-dev/${PROJECT}';
composer.description = title;
fs.writeFileSync(composerPath, JSON.stringify(composer, null, 2) + '\n');
let envEx = fs.readFileSync('.env.example', 'utf8');
envEx = envEx.replace(/^APP_NAME=.*/m, 'APP_NAME=\"' + title + '\"');
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

php artisan test --no-interaction || echo "scaffold-web: warn — tests failed (review before push)"

find . \( -name '.DS_Store' -o -name '._*' -o -name 'Thumbs.db' -o -name 'Desktop.ini' \) -delete 2>/dev/null || true

echo "scaffold-web: done ${WORKSPACE}"
