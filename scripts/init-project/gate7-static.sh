#!/usr/bin/env bash
# Gate 7 for static SPA sites (e.g. Enjaz gallery). Production only by default.
# Usage: gate7-static.sh <project> [fqdn]
# Example: gate7-static.sh enjaz enjaz.mnjz.in

set -euo pipefail

PROJECT="${1:?project name required}"
FQDN="${2:-${PROJECT}.mnjz.in}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_SECRETS="${HOME}/.cursor/secrets/monjizeen-dev.env"

if [[ ! -f "${ORG_SECRETS}" ]]; then
  echo "error: missing ${ORG_SECRETS}" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a && source "${ORG_SECRETS}" && set +a

VPS_SSH_HOST="${VPS_SSH_HOST:-vps}"
VPS_SSH_USER="${VPS_SSH_USER:-root}"
VPS_SSH="${VPS_SSH_USER}@${VPS_SSH_HOST}"
VPS_SHARED_ASSETS="${VPS_SHARED_ASSETS_PATH:-/srv/projects/shared-assets}"
DEPLOY_ROOT="/srv/projects/${PROJECT}"
PROD="${DEPLOY_ROOT}/production"
REPO="git@github.com:monjizeen-dev/${PROJECT}.git"

SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)

echo "gate7-static: DNS ${FQDN}"
"${SCRIPT_DIR}/dns.sh" "${PROJECT}" "${VPS_PUBLIC_IP:-}"

echo "gate7-static: SSH preflight ${VPS_SSH}"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "command -v nginx git certbot"

echo "gate7-static: sync init scripts to VPS"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ${VPS_SHARED_ASSETS}/scripts/init-project"
rsync -az "${SCRIPT_DIR}/" "${VPS_SSH}:${VPS_SHARED_ASSETS}/scripts/init-project/"

echo "gate7-static: remote setup"
ssh "${SSH_OPTS[@]}" "${VPS_SSH}" bash -s <<REMOTE
set -euo pipefail
PROJECT="${PROJECT}"
FQDN="${FQDN}"
PROD="${PROD}"
REPO="${REPO}"
SCRIPT_DIR="${VPS_SHARED_ASSETS}/scripts/init-project"

mkdir -p "\${PROD}/dist"
chown -R www-data:www-data "/srv/projects/\${PROJECT}"

if [[ ! -d "\${PROD}/.git" ]]; then
  if [[ -d "\${PROD}" && -n "\$(ls -A "\${PROD}" 2>/dev/null)" ]]; then
    rm -rf "\${PROD}"
  fi
  mkdir -p "\${PROD}"
  sudo -u www-data git clone "\${REPO}" "\${PROD}"
else
  sudo -u www-data bash -c "cd '\${PROD}' && git fetch origin main && git reset --hard origin/main"
fi

if [[ ! -d "/etc/letsencrypt/live/\${FQDN}" ]]; then
  if [[ -f "\${HOME}/.cursor/secrets/monjizeen-dev.env" ]]; then
    set -a && source "\${HOME}/.cursor/secrets/monjizeen-dev.env" && set +a
  fi
  if [[ -n "\${CERTBOT_EMAIL:-}" ]]; then
    certbot certonly --nginx -d "\${FQDN}" --non-interactive --agree-tos -m "\${CERTBOT_EMAIL}" || true
  fi
fi

bash "\${SCRIPT_DIR}/nginx-vhost-static.sh" "\${PROJECT}" "\${FQDN}" production

cd "\${PROD}"
sudo -u www-data npm ci
sudo -u www-data npm run build
REMOTE

echo "gate7-static: verify https://${FQDN}"
"${SCRIPT_DIR}/verify-static.sh" "${FQDN}"

echo "gate7-static: done — https://${FQDN}"
