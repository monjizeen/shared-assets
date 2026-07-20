#!/usr/bin/env bash
# Gate 7 from Mac: Cloudflare DNS locally, app/nginx/deploy on VPS via SSH.
#
# Usage:
#   gate7.sh <project> playground
#   gate7.sh <project> live <base-domain>
#
# playground → {project}.mnjz.in → /srv/projects/{project}/staging (no production)
# live       → staging.{domain} + app.{domain} → staging + production
#
# Requires ~/.cursor/secrets/monjizeen.env and project secrets (see mode).

set -euo pipefail

PROJECT="${1:?project name required}"
MODE="${2:?mode required: playground|live}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_SECRETS="${HOME}/.cursor/secrets/monjizeen.env"
PROJECT_SECRETS="${HOME}/.cursor/secrets/${PROJECT}.env"
PROJECT_SECRETS_PRODUCTION="${HOME}/.cursor/secrets/${PROJECT}-production.env"

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
VPS_IP="${VPS_PUBLIC_IP:-}"

SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)

case "${MODE}" in
  playground)
    STAGING_FQDN="${PROJECT}.mnjz.in"
    PRODUCTION_FQDN=""
    echo "gate7: DNS ${STAGING_FQDN}"
    "${SCRIPT_DIR}/dns.sh" "${PROJECT}" "${VPS_IP}"
    ;;
  live)
    DOMAIN="${3:?live mode requires base domain (e.g. monjizeen.com)}"
    STAGING_FQDN="staging.${DOMAIN}"
    PRODUCTION_FQDN="app.${DOMAIN}"
    if [[ ! -f "${PROJECT_SECRETS_PRODUCTION}" ]]; then
      echo "error: missing ${PROJECT_SECRETS_PRODUCTION} — live mode needs production OAuth secrets" >&2
      exit 1
    fi
    echo "gate7: DNS ${STAGING_FQDN}"
    "${SCRIPT_DIR}/dns-fqdn.sh" "${STAGING_FQDN}" "${VPS_IP}"
    echo "gate7: DNS ${PRODUCTION_FQDN}"
    "${SCRIPT_DIR}/dns-fqdn.sh" "${PRODUCTION_FQDN}" "${VPS_IP}"
    ;;
  *)
    echo "error: mode must be playground or live (got: ${MODE})" >&2
    exit 1
    ;;
esac

echo "gate7: SSH preflight ${VPS_SSH}"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "command -v nginx git composer npm certbot"

echo "gate7: sync init scripts to VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ${VPS_SHARED_ASSETS}/scripts/init-project"
rsync -az "${SCRIPT_DIR}/" "${VPS_SSH}:${VPS_SHARED_ASSETS}/scripts/init-project/"

echo "gate7: sync project secrets to VPS (chmod 600)"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ~/.cursor/secrets && chmod 700 ~/.cursor/secrets"
scp -q "${PROJECT_SECRETS}" "${VPS_SSH}:~/.cursor/secrets/${PROJECT}.env"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "chmod 600 ~/.cursor/secrets/${PROJECT}.env"
if [[ -n "${PRODUCTION_FQDN}" && -f "${PROJECT_SECRETS_PRODUCTION}" ]]; then
  scp -q "${PROJECT_SECRETS_PRODUCTION}" "${VPS_SSH}:~/.cursor/secrets/${PROJECT}-production.env"
  ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "chmod 600 ~/.cursor/secrets/${PROJECT}-production.env"
fi

echo "gate7: remote setup on VPS"
if [[ -n "${PRODUCTION_FQDN}" ]]; then
  ssh "${SSH_OPTS[@]}" "${VPS_SSH}" \
    "bash ${VPS_SHARED_ASSETS}/scripts/init-project/remote-setup.sh ${PROJECT} ${STAGING_FQDN} ${PRODUCTION_FQDN}"
else
  ssh "${SSH_OPTS[@]}" "${VPS_SSH}" \
    "bash ${VPS_SHARED_ASSETS}/scripts/init-project/remote-setup.sh ${PROJECT} ${STAGING_FQDN} -"
fi

echo "gate7: verify staging HTTPS + OAuth"
"${SCRIPT_DIR}/verify.sh" "${STAGING_FQDN}"

if [[ -n "${PRODUCTION_FQDN}" ]]; then
  echo "gate7: verify production HTTPS + OAuth"
  "${SCRIPT_DIR}/verify.sh" "${PRODUCTION_FQDN}"
  echo "gate7: done — staging https://${STAGING_FQDN}, production https://${PRODUCTION_FQDN}"
else
  echo "gate7: done — playground https://${STAGING_FQDN}"
fi
