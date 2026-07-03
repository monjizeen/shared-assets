#!/usr/bin/env bash
# Verify static site HTTPS. Usage: verify-static.sh <fqdn>

set -euo pipefail

FQDN="${1:?fqdn required}"

code="$(curl -sS -o /dev/null -w '%{http_code}' "https://${FQDN}/" || echo "000")"
if [[ "${code}" != "200" ]]; then
  echo "error: https://${FQDN}/ returned HTTP ${code}" >&2
  exit 1
fi

echo "verify-static: ok https://${FQDN}/ (${code})"
