#!/usr/bin/env bash
# Back-compat wrapper — prefer env-deploy.sh
# Usage: env-production.sh <project> <fqdn>
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env-deploy.sh" "$1" "$2" production
