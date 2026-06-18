#!/usr/bin/env bash
# Gate 7 from Mac: Cloudflare DNS locally, app/nginx/deploy on VPS via SSH.
# Usage: gate7.sh <project>
# Staging: staging-{project}.mnjz.in → /srv/projects/{project}/staging
# Production: app-{project}.mnjz.in → /srv/projects/{project}/production
# Requires ~/.cursor/secrets/monjizeen-dev.env, <project>.env (staging/local),
# and <project>-production.env on Mac.

set -euo pipefail

PROJECT="${1:?project name required}"
STAGING_FQDN="staging-${PROJECT}.mnjz.in"
PRODUCTION_FQDN="app-${PROJECT}.mnjz.in"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_SECRETS="${HOME}/.cursor/secrets/monjizeen-dev.env"
PROJECT_SECRETS="${HOME}/.cursor/secrets/${PROJECT}.env"
PROJECT_SECRETS_PRODUCTION="${HOME}/.cursor/secrets/${PROJECT}-production.env"

if [[ ! -f "${ORG_SECRETS}" ]]; then
  echo "error: missing ${ORG_SECRETS}" >&2
  exit 1
fi

if [[ ! -f "${PROJECT_SECRETS}" ]]; then
  echo "error: missing ${PROJECT_SECRETS} — complete Gate 5–6 (staging/local client) first" >&2
  exit 1
fi

if [[ ! -f "${PROJECT_SECRETS_PRODUCTION}" ]]; then
  echo "error: missing ${PROJECT_SECRETS_PRODUCTION} — complete Gate 5–6 (production client) first" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a && source "${ORG_SECRETS}" && set +a

VPS_SSH_HOST="${VPS_SSH_HOST:-vps}"
VPS_SSH_USER="${VPS_SSH_USER:-root}"
VPS_SSH="${VPS_SSH_USER}@${VPS_SSH_HOST}"
VPS_SHARED_ASSETS="${VPS_SHARED_ASSETS_PATH:-/srv/projects/shared-assets}"

SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)

echo "gate7: DNS ${STAGING_FQDN}"
"${SCRIPT_DIR}/dns.sh" "staging-${PROJECT}" "${VPS_PUBLIC_IP:-}"

echo "gate7: DNS ${PRODUCTION_FQDN}"
"${SCRIPT_DIR}/dns.sh" "app-${PROJECT}" "${VPS_PUBLIC_IP:-}"

echo "gate7: SSH preflight ${VPS_SSH}"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "command -v nginx git composer npm certbot"

echo "gate7: sync init scripts to VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ${VPS_SHARED_ASSETS}/scripts/init-project"
rsync -az "${SCRIPT_DIR}/" "${VPS_SSH}:${VPS_SHARED_ASSETS}/scripts/init-project/"

echo "gate7: sync project secrets to VPS (chmod 600)"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ~/.cursor/secrets && chmod 700 ~/.cursor/secrets"
scp -q "${PROJECT_SECRETS}" "${VPS_SSH}:~/.cursor/secrets/${PROJECT}.env"
scp -q "${PROJECT_SECRETS_PRODUCTION}" "${VPS_SSH}:~/.cursor/secrets/${PROJECT}-production.env"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "chmod 600 ~/.cursor/secrets/${PROJECT}.env ~/.cursor/secrets/${PROJECT}-production.env"

echo "gate7: remote setup on VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" \
  "bash ${VPS_SHARED_ASSETS}/scripts/init-project/remote-setup.sh ${PROJECT} ${STAGING_FQDN} ${PRODUCTION_FQDN}"

echo "gate7: verify staging HTTPS + OAuth"
"${SCRIPT_DIR}/verify.sh" "${STAGING_FQDN}"

echo "gate7: verify production HTTPS + OAuth"
"${SCRIPT_DIR}/verify.sh" "${PRODUCTION_FQDN}"

echo "gate7: done — staging https://${STAGING_FQDN}, production https://${PRODUCTION_FQDN}"
