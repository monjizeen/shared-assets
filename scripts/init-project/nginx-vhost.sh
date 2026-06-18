#!/usr/bin/env bash
# nginx vhost for {fqdn} → /srv/projects/{project}/{deploy_env}/public
# Exact server_name beats *.mnjz.in wildcard on this VPS.
# Usage: nginx-vhost.sh <project> <fqdn> [deploy_env]
# deploy_env: staging (default) or production

set -euo pipefail

PROJECT="${1:?project name required}"
FQDN="${2:?fqdn required}"
DEPLOY_ENV="${3:-staging}"

if [[ "${DEPLOY_ENV}" != "staging" && "${DEPLOY_ENV}" != "production" ]]; then
  echo "error: deploy_env must be staging or production" >&2
  exit 1
fi

SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"
CONF_NAME="${FQDN}"
CONF_PATH="${SITES_AVAILABLE}/${CONF_NAME}"

PHP_SOCK="$(grep -rh 'fastcgi_pass unix:' /etc/nginx/sites-enabled/ 2>/dev/null | head -1 | sed -n 's/.*unix:\([^;]*\).*/\1/p' || true)"
PHP_SOCK="${PHP_SOCK:-/var/run/php/php8.4-fpm.sock}"

if [[ -d "/etc/letsencrypt/live/${FQDN}" ]]; then
  SSL_CERT="/etc/letsencrypt/live/${FQDN}/fullchain.pem"
  SSL_KEY="/etc/letsencrypt/live/${FQDN}/privkey.pem"
elif [[ -d "/etc/letsencrypt/live/oc.mnjz.in" ]]; then
  SSL_CERT="/etc/letsencrypt/live/oc.mnjz.in/fullchain.pem"
  SSL_KEY="/etc/letsencrypt/live/oc.mnjz.in/privkey.pem"
else
  SSL_CERT="/etc/letsencrypt/live/app.monjizeen.com/fullchain.pem"
  SSL_KEY="/etc/letsencrypt/live/app.monjizeen.com/privkey.pem"
fi

tmp="$(mktemp)"
trap 'rm -f "${tmp}"' EXIT

cat > "${tmp}" <<NGINX
server {
    listen 80;
    listen [::]:80;
    server_name ${FQDN};
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${FQDN};

    root /srv/projects/${PROJECT}/${DEPLOY_ENV}/public;
    index index.php;

    ssl_certificate     ${SSL_CERT};
    ssl_certificate_key ${SSL_KEY};
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \\.php\$ {
        fastcgi_pass unix:${PHP_SOCK};
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_hide_header X-Powered-By;
    }

    location ~ /\\.(?!well-known).* {
        deny all;
    }
}
NGINX

cp "${tmp}" "${CONF_PATH}"
ln -sf "${CONF_PATH}" "${SITES_ENABLED}/${CONF_NAME}"
nginx -t
systemctl reload nginx

echo "nginx: ${FQDN} → /srv/projects/${PROJECT}/${DEPLOY_ENV}/public"
