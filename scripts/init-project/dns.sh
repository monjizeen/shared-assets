#!/usr/bin/env bash
# Create or update Cloudflare A record: {project}.mnjz.in → VPS IP
# Usage: dns.sh <project> [vps_ip]
# Requires: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID (env or monjizeen-dev.env)

set -euo pipefail

PROJECT="${1:?project name required}"
VPS_IP="${2:-${VPS_PUBLIC_IP:-}}"

if [[ -z "${VPS_IP}" ]]; then
  echo "error: VPS IP required as arg or VPS_PUBLIC_IP env var" >&2
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ZONE_ID:-}" ]]; then
  SECRETS="${HOME}/.cursor/secrets/monjizeen-dev.env"
  if [[ -f "${SECRETS}" ]]; then
    # shellcheck disable=SC1090
    set -a && source "${SECRETS}" && set +a
  fi
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ZONE_ID:-}" ]]; then
  echo "error: set CLOUDFLARE_API_TOKEN and CLOUDFLARE_ZONE_ID" >&2
  exit 1
fi

RECORD_NAME="${PROJECT}"
API="https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records"

existing="$(curl -sf -G "${API}" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  --data-urlencode "type=A" \
  --data-urlencode "name=${RECORD_NAME}" \
  | jq -r '.result[0].id // empty')"

payload="$(jq -n \
  --arg type "A" \
  --arg name "${RECORD_NAME}" \
  --arg content "${VPS_IP}" \
  '{type: $type, name: $name, content: $content, proxied: true, ttl: 1}')"

if [[ -n "${existing}" ]]; then
  curl -sf -X PUT "${API}/${existing}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "${payload}" | jq -e '.success' >/dev/null
  echo "dns: updated A ${RECORD_NAME}.mnjz.in → ${VPS_IP} (proxied)"
else
  curl -sf -X POST "${API}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "${payload}" | jq -e '.success' >/dev/null
  echo "dns: created A ${RECORD_NAME}.mnjz.in → ${VPS_IP} (proxied)"
fi
