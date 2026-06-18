#!/usr/bin/env bash
# Run ON VPS (invoked by gate7.sh over SSH). Idempotent.
# Usage: remote-setup.sh <project> [staging_fqdn] [production_fqdn]
# Defaults: staging-{project}.mnjz.in, app-{project}.mnjz.in

set -euo pipefail

PROJECT="${1:?project name required}"
STAGING_FQDN="${2:-staging-${PROJECT}.mnjz.in}"
PRODUCTION_FQDN="${3:-app-${PROJECT}.mnjz.in}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_ROOT="/srv/projects/${PROJECT}"
STAGING="${DEPLOY_ROOT}/staging"
PROD="${DEPLOY_ROOT}/production"
REPO="git@github.com:monjizeen-dev/${PROJECT}.git"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-}"

ensure_cert() {
  local fqdn="$1"
  if [[ -d "/etc/letsencrypt/live/${fqdn}" ]]; then
    return 0
  fi
  if [[ -z "${CERTBOT_EMAIL}" ]]; then
    if [[ -f "${HOME}/.cursor/secrets/monjizeen-dev.env" ]]; then
      # shellcheck disable=SC1090
      set -a && source "${HOME}/.cursor/secrets/monjizeen-dev.env" && set +a
    fi
  fi
  if [[ -n "${CERTBOT_EMAIL:-}" ]]; then
    echo "remote: certbot for ${fqdn}"
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

clone_or_update() {
  local path="$1"
  if [[ ! -d "${path}/.git" ]]; then
    sudo -u www-data git clone "${REPO}" "${path}"
  else
    sudo -u www-data bash -c "cd '${path}' && git fetch origin main && git reset --hard origin/main"
  fi
}

build_deploy() {
  local path="$1"
  local fqdn="$2"
  local deploy_env="$3"

  if [[ ! -f "${path}/.env" ]]; then
    sudo -u www-data cp "${path}/.env.example" "${path}/.env"
  fi

  bash "${SCRIPT_DIR}/env-deploy.sh" "${PROJECT}" "${fqdn}" "${deploy_env}"

  cd "${path}"
  sudo -u www-data composer install --no-dev --optimize-autoloader
  sudo -u www-data npm ci
  sudo -u www-data npm run build
  sudo -u www-data php artisan key:generate --force
  sudo -u www-data php artisan migrate --force
  sudo -u www-data php artisan config:cache
}

echo "remote: deploy dirs"
mkdir -p "${STAGING}" "${PROD}"
chown -R www-data:www-data "${DEPLOY_ROOT}"

echo "remote: nginx staging ${STAGING_FQDN}"
setup_vhost "${STAGING_FQDN}" staging

echo "remote: nginx production ${PRODUCTION_FQDN}"
setup_vhost "${PRODUCTION_FQDN}" production

echo "remote: clone staging + production"
clone_or_update "${STAGING}"
clone_or_update "${PROD}"

echo "remote: build staging ${STAGING_FQDN}"
build_deploy "${STAGING}" "${STAGING_FQDN}" staging

echo "remote: build production ${PRODUCTION_FQDN}"
build_deploy "${PROD}" "${PRODUCTION_FQDN}" production

echo "remote: setup complete — staging https://${STAGING_FQDN}, production https://${PRODUCTION_FQDN}"
