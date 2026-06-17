#!/usr/bin/env bash
# Gate 7 from Mac: Cloudflare DNS locally, app/nginx/deploy on VPS via SSH.
# Usage: gate7.sh <project> [fqdn]
# Requires ~/.cursor/secrets/monjizeen-dev.env and ~/.cursor/secrets/<project>.env on Mac.

set -euo pipefail

PROJECT="${1:?project name required}"
FQDN="${2:-${PROJECT}.mnjz.in}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_SECRETS="${HOME}/.cursor/secrets/monjizeen-dev.env"
PROJECT_SECRETS="${HOME}/.cursor/secrets/${PROJECT}.env"

if [[ ! -f "${ORG_SECRETS}" ]]; then
  echo "error: missing ${ORG_SECRETS}" >&2
  exit 1
fi

if [[ ! -f "${PROJECT_SECRETS}" ]]; then
  echo "error: missing ${PROJECT_SECRETS} — complete Gate 5–6 first" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a && source "${ORG_SECRETS}" && set +a

VPS_SSH_HOST="${VPS_SSH_HOST:-vps}"
VPS_SSH_USER="${VPS_SSH_USER:-root}"
VPS_SSH="${VPS_SSH_USER}@${VPS_SSH_HOST}"
VPS_SHARED_ASSETS="${VPS_SHARED_ASSETS_PATH:-/srv/projects/shared-assets}"

SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)

echo "gate7: DNS ${FQDN}"
"${SCRIPT_DIR}/dns.sh" "${PROJECT}" "${VPS_PUBLIC_IP:-}"

echo "gate7: SSH preflight ${VPS_SSH}"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "command -v nginx git composer npm certbot"

echo "gate7: sync init scripts to VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ${VPS_SHARED_ASSETS}/scripts/init-project"
rsync -az "${SCRIPT_DIR}/" "${VPS_SSH}:${VPS_SHARED_ASSETS}/scripts/init-project/"

echo "gate7: sync project secrets to VPS (chmod 600)"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ~/.cursor/secrets && chmod 700 ~/.cursor/secrets"
scp -q "${PROJECT_SECRETS}" "${VPS_SSH}:~/.cursor/secrets/${PROJECT}.env"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "chmod 600 ~/.cursor/secrets/${PROJECT}.env"

echo "gate7: remote setup on VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" \
  "bash ${VPS_SHARED_ASSETS}/scripts/init-project/remote-setup.sh ${PROJECT} ${FQDN}"

echo "gate7: verify HTTPS + OAuth redirect"
"${SCRIPT_DIR}/verify.sh" "${FQDN}"

echo "gate7: done — https://${FQDN}"
