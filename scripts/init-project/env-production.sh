#!/usr/bin/env bash
# Merge Google OAuth + APP_URL into production .env on VPS
# Usage: env-production.sh <project> <fqdn>
# Reads: ~/.cursor/secrets/{project}.env

set -euo pipefail

PROJECT="${1:?project name required}"
FQDN="${2:?fqdn required}"

DEPLOY_ENV="/srv/projects/${PROJECT}/production/.env"
SECRETS="${HOME}/.cursor/secrets/${PROJECT}.env"

if [[ ! -f "${DEPLOY_ENV}" ]]; then
  echo "error: ${DEPLOY_ENV} not found" >&2
  exit 1
fi

if [[ ! -f "${SECRETS}" ]]; then
  echo "error: ${SECRETS} not found — complete Gate 5 first" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a && source "${SECRETS}" && set +a

if [[ -z "${GOOGLE_CLIENT_ID:-}" || -z "${GOOGLE_CLIENT_SECRET:-}" ]]; then
  echo "error: GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET required in ${SECRETS}" >&2
  exit 1
fi

set_kv() {
  local key="$1"
  local value="$2"
  python3 - "${DEPLOY_ENV}" "${key}" "${value}" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
key = sys.argv[2]
value = sys.argv[3]
lines = path.read_text().splitlines() if path.exists() else []
out, found = [], False
for line in lines:
    if line.startswith(f"{key}="):
        out.append(f"{key}={value}")
        found = True
    else:
        out.append(line)
if not found:
    out.append(f"{key}={value}")
path.write_text("\n".join(out) + "\n")
PY
}

APP_URL="https://${FQDN}"
REDIRECT="${APP_URL}/auth/google/callback"

set_kv "APP_URL" "${APP_URL}"
set_kv "APP_ENV" "production"
set_kv "APP_DEBUG" "false"
set_kv "GOOGLE_CLIENT_ID" "${GOOGLE_CLIENT_ID}"
set_kv "GOOGLE_CLIENT_SECRET" "${GOOGLE_CLIENT_SECRET}"
set_kv "GOOGLE_REDIRECT_URI" "${REDIRECT}"

echo "env: updated ${DEPLOY_ENV} (APP_URL, GOOGLE_*)"