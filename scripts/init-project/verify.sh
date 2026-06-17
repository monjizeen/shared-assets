#!/usr/bin/env bash
# Smoke-test HTTPS and Google OAuth redirect
# Usage: verify.sh <fqdn>
# Example: verify.sh kawader.mnjz.in

set -euo pipefail

FQDN="${1:?fqdn required}"
BASE="https://${FQDN}"

echo "verify: GET ${BASE}"
headers="$(curl -sSI "${BASE}" | head -10)"
echo "${headers}"

if ! echo "${headers}" | grep -qiE 'HTTP/[0-9.]+ (200|302)'; then
  echo "error: expected 200 or 302 from ${BASE}" >&2
  exit 1
fi

echo "verify: GET ${BASE}/auth/google"
oauth_headers="$(curl -sSI "${BASE}/auth/google" | head -15)"
echo "${oauth_headers}"

if echo "${oauth_headers}" | grep -qi 'accounts.google.com'; then
  echo "verify: OAuth redirect OK"
elif echo "${oauth_headers}" | grep -qiE 'HTTP/[0-9.]+ 302'; then
  echo "verify: 302 redirect present (check Location manually if not Google)"
else
  echo "warn: OAuth redirect may not be configured — check GOOGLE_* in .env" >&2
  exit 1
fi

echo "verify: all checks passed for ${FQDN}"
