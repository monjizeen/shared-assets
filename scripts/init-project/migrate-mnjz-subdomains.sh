#!/usr/bin/env bash
# Migrate legacy mnjz.in hostnames to current init-project convention.
# Old: staging-{project}.mnjz.in, app-{project}.mnjz.in
# New: {project}-staging.mnjz.in, {project}.mnjz.in
#
# Usage (Mac, with org secrets): migrate-mnjz-subdomains.sh <project> [project...]
# Idempotent. Creates DNS (Cloudflare), nginx vhosts, certs, APP_URL on VPS.
# Removes legacy nginx vhosts when new ones are in place.

set -euo pipefail

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
SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)

migrate_project() {
  local project="$1"
  local staging_fqdn="${project}-staging.mnjz.in"
  local production_fqdn="${project}.mnjz.in"
  local old_staging="staging-${project}.mnjz.in"
  local old_production="app-${project}.mnjz.in"

  echo "migrate: ${project}"

  echo "migrate: DNS ${staging_fqdn}"
  "${SCRIPT_DIR}/dns.sh" "${project}-staging" "${VPS_PUBLIC_IP:-}"

  echo "migrate: DNS ${production_fqdn}"
  "${SCRIPT_DIR}/dns.sh" "${project}" "${VPS_PUBLIC_IP:-}"

  echo "migrate: wait for DNS propagation"
  sleep 30

  echo "migrate: sync scripts to VPS"
  ssh "${SSH_OPTS[@]}" "${VPS_SSH}" "mkdir -p ${VPS_SHARED_ASSETS}/scripts/init-project"
  rsync -az "${SCRIPT_DIR}/" "${VPS_SSH}:${VPS_SHARED_ASSETS}/scripts/init-project/"

  echo "migrate: remote nginx + env"
  ssh "${SSH_OPTS[@]}" "${VPS_SSH}" bash -s -- "${project}" "${staging_fqdn}" "${production_fqdn}" "${old_staging}" "${old_production}" <<'REMOTE'
set -euo pipefail
PROJECT="$1"
STAGING_FQDN="$2"
PRODUCTION_FQDN="$3"
OLD_STAGING="$4"
OLD_PRODUCTION="$5"
SCRIPT_DIR="${VPS_SHARED_ASSETS_PATH:-/srv/projects/shared-assets}/scripts/init-project"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-}"

if [[ -z "${CERTBOT_EMAIL}" && -f "${HOME}/.cursor/secrets/monjizeen-dev.env" ]]; then
  # shellcheck disable=SC1090
  set -a && source "${HOME}/.cursor/secrets/monjizeen-dev.env" && set +a
fi

ensure_cert() {
  local fqdn="$1"
  if [[ -d "/etc/letsencrypt/live/${fqdn}" ]]; then
    return 0
  fi
  if [[ -n "${CERTBOT_EMAIL:-}" ]]; then
    certbot certonly --nginx -d "${fqdn}" --non-interactive --agree-tos -m "${CERTBOT_EMAIL}" || true
  else
    echo "warn: CERTBOT_EMAIL unset — skip certbot for ${fqdn}" >&2
  fi
}

setup_vhost() {
  local fqdn="$1"
  local deploy_env="$2"
  ensure_cert "${fqdn}"
  bash "${SCRIPT_DIR}/nginx-vhost.sh" "${PROJECT}" "${fqdn}" "${deploy_env}"
}

setup_vhost "${STAGING_FQDN}" staging
setup_vhost "${PRODUCTION_FQDN}" production

if [[ ! -f "/srv/projects/${PROJECT}/production/.env" && -f "/srv/projects/${PROJECT}/production/.env.example" ]]; then
  sudo -u www-data cp "/srv/projects/${PROJECT}/production/.env.example" "/srv/projects/${PROJECT}/production/.env"
fi

bash "${SCRIPT_DIR}/env-deploy.sh" "${PROJECT}" "${STAGING_FQDN}" staging
if [[ -f "/srv/projects/${PROJECT}/production/.env" ]]; then
  bash "${SCRIPT_DIR}/env-deploy.sh" "${PROJECT}" "${PRODUCTION_FQDN}" production
fi

sudo -u www-data bash -c "cd /srv/projects/${PROJECT}/staging && php artisan config:cache" 2>/dev/null || true
if [[ -f "/srv/projects/${PROJECT}/production/.env" ]]; then
  sudo -u www-data bash -c "cd /srv/projects/${PROJECT}/production && php artisan config:cache" 2>/dev/null || true
fi

for old in "${OLD_STAGING}" "${OLD_PRODUCTION}"; do
  rm -f "/etc/nginx/sites-enabled/${old}"
  rm -f "/etc/nginx/sites-available/${old}"
done

nginx -t
systemctl reload nginx

echo "remote: ${PROJECT} → https://${STAGING_FQDN}, https://${PRODUCTION_FQDN}"
REMOTE

  echo "migrate: verify ${staging_fqdn}"
  "${SCRIPT_DIR}/verify.sh" "${staging_fqdn}" || true

  echo "migrate: verify ${production_fqdn}"
  "${SCRIPT_DIR}/verify.sh" "${production_fqdn}" || true

  echo "migrate: done ${project}"
}

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <project> [project...]" >&2
  exit 1
fi

for project in "$@"; do
  migrate_project "${project}"
done

echo "migrate: all done — update Google OAuth redirect URIs for each project"
