#!/usr/bin/env bash
# Create or update Cloudflare A record for a full FQDN (any zone the token can edit).
# Usage: dns-fqdn.sh <fqdn> [vps_ip]
# Example: dns-fqdn.sh staging.monjizeen.com
# Looks up the Cloudflare zone by walking parent labels (staging.foo.com → foo.com).
# Requires: CLOUDFLARE_API_TOKEN (env or monjizeen.env)

set -euo pipefail

FQDN="${1:?FQDN required (e.g. staging.monjizeen.com)}"
VPS_IP="${2:-${VPS_PUBLIC_IP:-}}"

if [[ -z "${VPS_IP}" ]]; then
  echo "error: VPS IP required as arg or VPS_PUBLIC_IP env var" >&2
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  SECRETS="${HOME}/.cursor/secrets/monjizeen.env"
  if [[ -f "${SECRETS}" ]]; then
    # shellcheck disable=SC1090
    set -a && source "${SECRETS}" && set +a
  fi
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "error: set CLOUDFLARE_API_TOKEN" >&2
  exit 1
fi

# Find zone: try FQDN parents until a zone matches (skip the leftmost label for subdomains).
find_zone_id() {
  local name="$1"
  local candidate parts
  IFS='.' read -r -a parts <<< "${name}"
  local i
  for ((i = 0; i < ${#parts[@]} - 1; i++)); do
    candidate="$(IFS='.'; echo "${parts[*]:$i}")"
    local zid
    zid="$(curl -sf -G "https://api.cloudflare.com/client/v4/zones" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --data-urlencode "name=${candidate}" \
      | jq -r '.result[0].id // empty')"
    if [[ -n "${zid}" ]]; then
      echo "${zid}"
      return 0
    fi
  done
  return 1
}

ZONE_ID="$(find_zone_id "${FQDN}" || true)"
if [[ -z "${ZONE_ID}" ]]; then
  echo "error: no Cloudflare zone found for ${FQDN} — add the domain to Cloudflare first" >&2
  exit 1
fi

API="https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records"

existing="$(curl -sf -G "${API}" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  --data-urlencode "type=A" \
  --data-urlencode "name=${FQDN}" \
  | jq -r '.result[0].id // empty')"

payload="$(jq -n \
  --arg type "A" \
  --arg name "${FQDN}" \
  --arg content "${VPS_IP}" \
  '{type: $type, name: $name, content: $content, proxied: true, ttl: 1}')"

if [[ -n "${existing}" ]]; then
  curl -sf -X PUT "${API}/${existing}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "${payload}" | jq -e '.success' >/dev/null
  echo "dns: updated A ${FQDN} → ${VPS_IP} (proxied)"
else
  curl -sf -X POST "${API}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "${payload}" | jq -e '.success' >/dev/null
  echo "dns: created A ${FQDN} → ${VPS_IP} (proxied)"
fi
