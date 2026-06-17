#!/usr/bin/env bash
# Run ON VPS (invoked by gate7.sh over SSH). Idempotent.
# Usage: remote-setup.sh <project> <fqdn>

set -euo pipefail

PROJECT="${1:?project name required}"
FQDN="${2:?fqdn required}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_ROOT="/srv/projects/${PROJECT}"
PROD="${DEPLOY_ROOT}/production"
REPO="git@github.com:monjizeen-dev/${PROJECT}.git"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-}"

echo "remote: nginx vhost ${FQDN}"
bash "${SCRIPT_DIR}/nginx-vhost.sh" "${PROJECT}" "${FQDN}"

if [[ ! -d "/etc/letsencrypt/live/${FQDN}" ]]; then
  if [[ -z "${CERTBOT_EMAIL}" ]]; then
    if [[ -f "${HOME}/.cursor/secrets/monjizeen-dev.env" ]]; then
      # shellcheck disable=SC1090
      set -a && source "${HOME}/.cursor/secrets/monjizeen-dev.env" && set +a
    fi
  fi
  if [[ -n "${CERTBOT_EMAIL:-}" ]]; then
    echo "remote: certbot for ${FQDN}"
    certbot certonly --nginx -d "${FQDN}" --non-interactive --agree-tos -m "${CERTBOT_EMAIL}" || true
    if [[ -d "/etc/letsencrypt/live/${FQDN}" ]]; then
      bash "${SCRIPT_DIR}/nginx-vhost.sh" "${PROJECT}" "${FQDN}"
    else
      echo "warn: no cert for ${FQDN} — set CERTBOT_EMAIL in monjizeen-dev.env and re-run" >&2
    fi
  else
    echo "warn: CERTBOT_EMAIL unset — skip certbot; fix SSL manually" >&2
  fi
fi

echo "remote: deploy dirs"
mkdir -p "${DEPLOY_ROOT}/"{staging,production}
chown -R www-data:www-data "${DEPLOY_ROOT}"

if [[ ! -d "${PROD}/.git" ]]; then
  sudo -u www-data git clone "${REPO}" "${PROD}"
else
  sudo -u www-data bash -c "cd '${PROD}' && git fetch origin main && git reset --hard origin/main"
fi

if [[ ! -f "${PROD}/.env" ]]; then
  sudo -u www-data cp "${PROD}/.env.example" "${PROD}/.env"
fi

echo "remote: production .env"
bash "${SCRIPT_DIR}/env-production.sh" "${PROJECT}" "${FQDN}"

echo "remote: build ${PROD}"
cd "${PROD}"
sudo -u www-data composer install --no-dev --optimize-autoloader
sudo -u www-data npm ci
sudo -u www-data npm run build
sudo -u www-data php artisan key:generate --force
sudo -u www-data php artisan migrate --force
sudo -u www-data php artisan config:cache

echo "remote: setup complete for ${FQDN}"
