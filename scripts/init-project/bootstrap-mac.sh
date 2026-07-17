#!/usr/bin/env bash
# Bootstrap a Mac for init-project: skill symlink, secrets, SSH, tools.
# Idempotent. Safe to re-run. Never prints secret values.
#
# Usage: bootstrap-mac.sh [shared-assets-root]
# Exit 0 if ready; exit 1 if manual steps still required.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_ASSETS_ROOT="${1:-${SHARED_ASSETS_ROOT:-}}"

find_shared_assets() {
  local candidates=()
  if [[ -n "${SHARED_ASSETS_ROOT}" ]]; then
    candidates+=("${SHARED_ASSETS_ROOT}")
  fi
  candidates+=(
    "${HOME}/Documents/work/projects/monjizeen/shared-assets"
    "${HOME}/work/projects/monjizeen/shared-assets"
    "${HOME}/projects/monjizeen/shared-assets"
  )
  local d
  for d in "${candidates[@]}"; do
    if [[ -f "${d}/skills/init-project/SKILL.md" ]]; then
      echo "${d}"
      return 0
    fi
  done
  return 1
}

ok()  { echo "bootstrap: ok   $*"; }
fix() { echo "bootstrap: fix  $*"; }
warn(){ echo "bootstrap: warn $*" >&2; }
need(){ echo "bootstrap: need $*" >&2; NEED_MANUAL=1; }

NEED_MANUAL=0
SHARED_ASSETS="$(find_shared_assets)" || {
  need "clone monjizeen/shared-assets (skill not found). Example:"
  need "  git clone git@github.com:monjizeen/shared-assets.git ~/Documents/work/projects/monjizeen/shared-assets"
  SHARED_ASSETS=""
}

# --- Org repos + cursor-runtime + skills (refresh-mora) ---
MONO_ROOT="$(cd "${SHARED_ASSETS}/.." && pwd)"
if [[ -n "${SHARED_ASSETS}" ]]; then
  if [[ ! -d "${MONO_ROOT}/mora/.git" ]]; then
    if git clone "git@github.com:monjizeen/mora.git" "${MONO_ROOT}/mora" 2>/dev/null; then
      fix "cloned mora → ${MONO_ROOT}/mora"
    else
      need "clone mora: git clone git@github.com:monjizeen/mora.git ${MONO_ROOT}/mora"
    fi
  fi
  if [[ -f "${MONO_ROOT}/mora/scripts/refresh-mora.sh" ]]; then
    if "${MONO_ROOT}/mora/scripts/refresh-mora.sh" "${MONO_ROOT}"; then
      ok "refresh-mora"
    else
      need "fix refresh-mora (${MONO_ROOT}/mora/scripts/refresh-mora.sh)"
    fi
  else
    need "mora/scripts/refresh-mora.sh missing after clone"
  fi
fi

# --- Secrets directory ---
mkdir -p "${HOME}/.cursor/secrets"
chmod 700 "${HOME}/.cursor/secrets"
ORG_SECRETS="${HOME}/.cursor/secrets/monjizeen.env"

# --- SSH config: ensure Host vps exists ---
SSH_CONFIG="${HOME}/.ssh/config"
detect_vps_identity_file() {
  local ip="${1:-187.77.109.160}"
  local key=""
  if [[ -f "${SSH_CONFIG}" ]]; then
    # Reuse Host root IdentityFile when it targets the same VPS IP.
    key="$(python3 - "${SSH_CONFIG}" "${ip}" <<'PY'
import re, sys
path, ip = sys.argv[1:3]
text = open(path, encoding="utf-8").read()
blocks = re.split(r"(?m)^Host\s+", text)
for block in blocks[1:]:
    lines = block.splitlines()
    name = lines[0].strip()
    if name != "root":
        continue
    body = "\n".join(lines[1:])
    host = re.search(r"(?m)^\s*HostName\s+(\S+)", body)
    ident = re.search(r"(?m)^\s*IdentityFile\s+(\S+)", body)
    if host and host.group(1) == ip and ident:
        print(ident.group(1))
        break
PY
)"
    if [[ -n "${key}" ]]; then
      echo "${key}"
      return 0
    fi
  fi
  for candidate in \
    "${HOME}/.ssh/access_to_vps_root_from_jasmine_macbook" \
    "${HOME}/.ssh/id_ed25519"; do
    if [[ -f "${candidate}" ]]; then
      echo "${candidate}"
      return 0
    fi
  done
  echo "${HOME}/.ssh/id_ed25519"
}

ensure_ssh_vps() {
  local ip="${1:-187.77.109.160}"
  local identity
  identity="$(detect_vps_identity_file "${ip}")"

  if [[ -f "${SSH_CONFIG}" ]] && grep -qE '^[Hh]ost[[:space:]]+vps\b' "${SSH_CONFIG}"; then
    if ssh -o BatchMode=yes -o ConnectTimeout=10 vps 'hostname' >/dev/null 2>&1; then
      ok "ssh config Host vps"
      return 0
    fi
    fix "Host vps exists but SSH failed — updating IdentityFile"
    python3 - "${SSH_CONFIG}" "${identity}" "${ip}" <<'PY'
import re, sys
path, identity, ip = sys.argv[1:4]
text = open(path, encoding="utf-8").read()
pattern = re.compile(
    r"(# monjizeen VPS \(added by init-project bootstrap\)\n)?"
    r"Host vps\n"
    r"(?:.*\n)*?"
    r"(?=Host |\Z)",
    re.MULTILINE,
)
replacement = (
    "# monjizeen VPS (added by init-project bootstrap)\n"
    f"Host vps\n"
    f"    HostName {ip}\n"
    f"    User root\n"
    f"    IdentityFile {identity}\n"
    f"    IdentitiesOnly yes\n\n"
)
if pattern.search(text):
    text = pattern.sub(replacement, text, count=1)
else:
    text = text.rstrip() + "\n\n" + replacement
open(path, "w", encoding="utf-8").write(text)
PY
    if ssh -o BatchMode=yes -o ConnectTimeout=10 vps 'hostname' >/dev/null 2>&1; then
      ok "ssh config Host vps (repaired)"
    else
      need "SSH still fails for Host vps — check key ${identity}"
    fi
    return 0
  fi

  mkdir -p "${HOME}/.ssh"
  chmod 700 "${HOME}/.ssh"
  cat >> "${SSH_CONFIG}" <<EOF

# monjizeen VPS (added by init-project bootstrap)
Host vps
    HostName ${ip}
    User root
    IdentityFile ${identity}
    IdentitiesOnly yes
EOF
  fix "appended Host vps to ~/.ssh/config"
}

# --- Org secrets file ---
fetch_secrets_from_vps() {
  local ssh_target="${1:-vps}"
  if ! ssh -o BatchMode=yes -o ConnectTimeout=10 "${ssh_target}" 'test -f ~/.cursor/secrets/monjizeen.env' 2>/dev/null; then
    return 1
  fi
  scp -q "${ssh_target}:~/.cursor/secrets/monjizeen.env" "${ORG_SECRETS}.tmp"
  chmod 600 "${ORG_SECRETS}.tmp"
  mv "${ORG_SECRETS}.tmp" "${ORG_SECRETS}"
  fix "pulled ${ORG_SECRETS} from VPS (${ssh_target})"
  return 0
}

build_secrets_from_vps_cloudflare() {
  local ssh_target="${1:-vps}"
  if ! ssh -o BatchMode=yes -o ConnectTimeout=10 "${ssh_target}" 'test -f /root/.cloudflare/cloudflare.ini' 2>/dev/null; then
    return 1
  fi
  umask 077
  ssh -o BatchMode=yes "${ssh_target}" 'python3 <<'"'"'PY'"'"'
import re, json, urllib.request
from pathlib import Path
ini = Path("/root/.cloudflare/cloudflare.ini").read_text()
m = re.search(r"dns_cloudflare_api_token\s*=\s*(.+)", ini)
if not m:
    raise SystemExit(1)
token = m.group(1).strip()
req = urllib.request.Request(
    "https://api.cloudflare.com/client/v4/zones?name=mnjz.in",
    headers={"Authorization": f"Bearer {token}"},
)
with urllib.request.urlopen(req) as resp:
    zone_id = json.load(resp)["result"][0]["id"]
email = "omaronweb@gmail.com"
for p in Path("/etc/letsencrypt/renewal").glob("*.conf"):
    for line in p.read_text().splitlines():
        if line.startswith("email = "):
            email = line.split("=", 1)[1].strip()
            break
    else:
        continue
    break
print(token)
print(zone_id)
print(email)
PY' | {
    read -r CF_TOKEN
    read -r CF_ZONE
    read -r CF_EMAIL
    cat > "${ORG_SECRETS}" <<EOF
# monjizeen org secrets — built from VPS cloudflare.ini
CLOUDFLARE_API_TOKEN=${CF_TOKEN}
CLOUDFLARE_ZONE_ID=${CF_ZONE}
VPS_PUBLIC_IP=187.77.109.160
VPS_SSH_HOST=vps
VPS_SSH_USER=root
VPS_SHARED_ASSETS_PATH=/srv/projects/shared-assets
CERTBOT_EMAIL=${CF_EMAIL}
EOF
    chmod 600 "${ORG_SECRETS}"
  }
  fix "built ${ORG_SECRETS} from VPS Cloudflare config"
  return 0
}

if [[ ! -f "${ORG_SECRETS}" ]]; then
  ensure_ssh_vps
  if fetch_secrets_from_vps vps || build_secrets_from_vps_cloudflare vps; then
    :
  else
    need "create ${ORG_SECRETS} — SSH to VPS failed or no cloudflare.ini"
    need "  copy from another Mac, or fill template in skills/init-project/reference.md"
  fi
else
  ok "org secrets file exists"
fi

# Validate required keys (without printing values)
if [[ -f "${ORG_SECRETS}" ]]; then
  # shellcheck disable=SC1090
  set -a && source "${ORG_SECRETS}" && set +a
  for key in CLOUDFLARE_API_TOKEN CLOUDFLARE_ZONE_ID VPS_PUBLIC_IP; do
    if [[ -z "${!key:-}" ]]; then
      need "${ORG_SECRETS} missing ${key}"
    fi
  done
  VPS_SSH_HOST="${VPS_SSH_HOST:-vps}"
  VPS_SSH_USER="${VPS_SSH_USER:-root}"
fi

# --- Shell auto-source (optional, idempotent) ---
ZSHRC="${HOME}/.zshrc"
SOURCE_LINE='[ -f ~/.cursor/secrets/monjizeen.env ] && source ~/.cursor/secrets/monjizeen.env'
if [[ -f "${ZSHRC}" ]] && ! grep -qF 'monjizeen.env' "${ZSHRC}" 2>/dev/null; then
  printf '\n# monjizeen init-project secrets\n%s\n' "${SOURCE_LINE}" >> "${ZSHRC}"
  fix "added secrets source line to ~/.zshrc"
elif [[ -f "${ZSHRC}" ]]; then
  ok "zshrc already sources org secrets"
fi

# --- CLI tools ---
for cmd in git ssh scp curl python3 jq; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    ok "tool ${cmd}"
  else
    need "install ${cmd}"
  fi
done

if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    ok "gh authenticated"
  else
    need "run: gh auth login"
  fi
else
  need "install gh (brew install gh)"
fi

for cmd in composer npm; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    ok "tool ${cmd}"
  else
    warn "optional for Gate 0, required for Gate 3: install ${cmd}"
  fi
done

# --- SSH preflight ---
if [[ -f "${ORG_SECRETS}" ]]; then
  # shellcheck disable=SC1090
  set -a && source "${ORG_SECRETS}" && set +a
  if ssh -o BatchMode=yes -o ConnectTimeout=10 "${VPS_SSH_USER}@${VPS_SSH_HOST}" 'hostname' >/dev/null 2>&1; then
    ok "SSH ${VPS_SSH_USER}@${VPS_SSH_HOST}"
  else
    need "SSH failed for ${VPS_SSH_USER}@${VPS_SSH_HOST} — check key (~/.ssh/id_ed25519) and ~/.ssh/config"
  fi
fi

# --- Cloudflare API smoke test ---
if [[ -f "${ORG_SECRETS}" && -n "${CLOUDFLARE_API_TOKEN:-}" && -n "${CLOUDFLARE_ZONE_ID:-}" ]]; then
  if curl -sf -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}" \
    | jq -e '.success' >/dev/null 2>&1; then
    ok "Cloudflare API (zone mnjz.in)"
  else
    need "Cloudflare token/zone invalid — refresh ${ORG_SECRETS}"
  fi
fi

echo ""
if [[ "${NEED_MANUAL}" -eq 0 ]]; then
  echo "bootstrap: READY — run /new-project"
  exit 0
fi
echo "bootstrap: INCOMPLETE — fix items marked 'need' above, then re-run:"
echo "  ${SCRIPT_DIR}/bootstrap-mac.sh"
exit 1
