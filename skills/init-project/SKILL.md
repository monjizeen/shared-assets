---
name: init-project
description: >
  Step-by-step monjizeen-dev project initiation: GitHub repo, Laravel+Inertia
  scaffold, MORA registry, Google OAuth setup, mnjz.in subdomain, VPS deploy
  paths. Pauses for manual inputs at each gate. Use when user says init project,
  new project, set up project, project initiation, or /init-project.
disable-model-invocation: true
---

# Init Project

Bootstrap a new monjizeen-dev product end-to-end. **Work step by step.** At each **GATE**, collect required input (use `AskQuestion` when available), then continue. Never skip a gate. Never print secrets.

## Constants

| Key | Value |
|-----|-------|
| GitHub org | `monjizeen-dev` |
| Local monorepo root | `~/Documents/work/projects/monjizeen-dev` |
| Root domain | `mnjz.in` |
| Subdomain | `{project}.mnjz.in` |
| OAuth callback | `https://{project}.mnjz.in/auth/google/callback` |
| VPS deploy paths | `/srv/projects/{project}/staging`, `/srv/projects/{project}/production` |
| Org secrets file | `~/.cursor/secrets/monjizeen-dev.env` |
| Project secrets file | `~/.cursor/secrets/{project}.env` |
| Scaffold template | `kawader` (Laravel 13 + Inertia + Vue 3 + Socialite) |
| Init scripts | `shared-assets/scripts/init-project/` |

Read [reference.md](reference.md) for file templates (CI, nginx, REGISTRY, agent stub).

---

## Progress checklist

Copy and update after each gate:

```
Init project: {project}
- [ ] Gate 0 — Prerequisites
- [ ] Gate 1 — Project identity
- [ ] Gate 2 — GitHub repo
- [ ] Gate 3 — Scaffold & first push
- [ ] Gate 4 — MORA registry + agent
- [ ] Gate 5 — Google OAuth (manual)
- [ ] Gate 6 — Secrets on disk
- [ ] Gate 7 — VPS: DNS + nginx + deploy dirs
- [ ] Gate 8 — CI workflow
- [ ] Gate 9 — Verify & handoff
```

---

## Gate 0 — Prerequisites

Verify tools exist. If anything missing, tell user how to install, then **stop**.

```bash
command -v gh && gh auth status
command -v git && command -v composer && command -v npm
command -v python3   # mora sync-registry.py
```

Confirm org secrets file exists (do not read or display values):

```bash
test -f ~/.cursor/secrets/monjizeen-dev.env && echo "org secrets: ok" || echo "org secrets: MISSING"
```

Required keys in `~/.cursor/secrets/monjizeen-dev.env` (user fills once on **each Mac** that runs init):

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ZONE_ID`
- `VPS_PUBLIC_IP`
- `VPS_SSH_HOST` — SSH config alias (default: `vps`)
- `VPS_SSH_USER` — SSH user (default: `root`)
- `CERTBOT_EMAIL` — Let's Encrypt contact (for new `*.mnjz.in` app certs)
- `VPS_SHARED_ASSETS_PATH` — optional (default: `/srv/projects/shared-assets`)

Verify SSH from Mac (no VPS Cursor session needed):

```bash
set -a && source ~/.cursor/secrets/monjizeen-dev.env && set +a
ssh -o BatchMode=yes "${VPS_SSH_USER:-root}@${VPS_SSH_HOST:-vps}" 'hostname && nginx -v'
```

Install skill symlink on **each Mac** (repo path is not auto-loaded by Cursor):

```bash
ln -sf ~/Documents/work/projects/monjizeen-dev/shared-assets/skills/init-project \
  ~/.cursor/skills/init-project
```

If missing, show user [reference.md — One-time bootstrap](reference.md#one-time-bootstrap) and **wait** until they confirm file exists.

---

## Gate 1 — Project identity

**Ask the user** (required):

1. **Project name** — lowercase kebab-case (e.g. `my-app`). Drives repo name, subdomain, paths.
2. **One-line purpose** — for MORA `REGISTRY.yaml` (e.g. "Talent directory").
3. **Auth model** — `open` (auto-create users on Google sign-in) or `closed` (only existing users/admins, like monjizeen).
4. **Run VPS setup now?** — default `yes` if SSH preflight passes; `later` skips Gate 7 until user asks.

Validate project name: `^[a-z][a-z0-9-]*[a-z0-9]$`, length 2–40, not reserved (`mora`, `shared-assets`).

Set for the rest of the run:

- `PROJECT` = name
- `FQDN` = `{PROJECT}.mnjz.in`
- `REPO` = `monjizeen-dev/{PROJECT}`
- `WORKSPACE` = `~/Documents/work/projects/monjizeen-dev/{PROJECT}`

Confirm summary with user before Gate 2.

---

## Gate 2 — GitHub repo

Create repo (private default unless user said public):

```bash
cd ~/Documents/work/projects/monjizeen-dev
gh repo create "monjizeen-dev/${PROJECT}" --private --description "{purpose}" --confirm
```

If repo already exists, `gh repo view monjizeen-dev/${PROJECT}` and continue.

---

## Gate 3 — Scaffold & first push

If `WORKSPACE` does not exist, scaffold from template:

```bash
cd ~/Documents/work/projects/monjizeen-dev
# Copy kawader as base; strip git history and project-specific bits
rsync -a --exclude '.git' --exclude 'database/database.sqlite' --exclude 'node_modules' --exclude 'vendor' \
  kawader/ "${PROJECT}/"
cd "${PROJECT}"
rm -f database/database.sqlite
git init
git branch -M main
```

Then customize (agent does this):

1. `composer.json` / `package.json` — set `name` / description for `{PROJECT}`.
2. `.env.example` — `APP_NAME`, keep `GOOGLE_*` placeholders (see reference.md).
3. `README.md` — replace boilerplate with project purpose + local setup.
4. `docs/ARCHITECTURE.md` — update title and purpose; keep stack/layering sections.
5. If auth model is `closed`, note in README that sign-in matches monjizeen pattern (implement separately).
6. Remove kawader-specific routes/models the new project does not need **only if** user asked for minimal scaffold; default: keep OAuth + dashboard shell, delete domain models later.

```bash
composer install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate --seed   # only if default migrations apply; else migrate without seed
npm install && npm run build
php artisan test || true       # report failures; do not block init if template tests need tweak
```

Initial commit:

```bash
git add -A
git commit -m "$(cat <<EOF
chore: initial scaffold for ${PROJECT}

Laravel + Inertia + Vue 3 + Google OAuth from org template.
EOF
)"
git remote add origin "git@github.com:monjizeen-dev/${PROJECT}.git" 2>/dev/null || true
git push -u origin main
```

---

## Gate 4 — MORA registry + agent

1. Edit `mora/REGISTRY.yaml` — add repo under `domains.monjizeen-dev.repos` (template in reference.md).
2. Create `mora/domains/monjizeen-dev/agents/{PROJECT}/SKILL.md` and `MEMORY.md` (templates in reference.md).
3. Regenerate JSON:

```bash
cd ~/Documents/work/projects/monjizeen-dev/mora
python3 scripts/sync-registry.py
```

Commit in `mora` repo only if user asked to commit; otherwise list files changed.

---

## Gate 5 — Google OAuth (manual — STOP here)

**Do not continue until user confirms OAuth client is created and creds are ready.**

Show this block verbatim (fill `{PROJECT}` and `{FQDN}`):

---

### Google OAuth setup for `{PROJECT}`

**1. OAuth consent screen** (once per GCP project, skip if already done)

- Open: https://console.cloud.google.com/apis/credentials/consent
- User type: External (or Internal if Google Workspace)
- Add authorized domain: `mnjz.in`

**2. Create OAuth client** (one per app — do this now)

- Open: https://console.cloud.google.com/apis/credentials/oauthclient
- Application type: **Web application**
- Name: `{PROJECT} production` (or similar)
- **Authorized JavaScript origins:** `https://{FQDN}`
- **Authorized redirect URIs:** `https://{FQDN}/auth/google/callback`
- For local dev, also add:
  - Origin: `http://127.0.0.1:8000`
  - Redirect: `http://127.0.0.1:8000/auth/google/callback`
- Click **Create**

**3. Save credentials**

Google shows **Client ID** and **Client secret** only once. Copy both.

**4. Tell me when done**

Reply with one of:

- `done` — and you will paste Client ID + Client secret in chat (agent writes secrets file), **or**
- `saved` — you already wrote them to `~/.cursor/secrets/{PROJECT}.env`

---

**Ask user** to confirm `done` or `saved`. If `done`, accept creds and write secrets file (Gate 6). Never echo secrets back.

---

## Gate 6 — Secrets on disk

Write project secrets file (mode 600):

```bash
mkdir -p ~/.cursor/secrets
cat > "~/.cursor/secrets/${PROJECT}.env" <<'ENVEOF'
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
ENVEOF
chmod 600 "~/.cursor/secrets/${PROJECT}.env"
```

Update local dev `.env` in workspace (not committed):

```env
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GOOGLE_REDIRECT_URI=http://127.0.0.1:8000/auth/google/callback
```

If Gate 1 answer was `later` for VPS, **skip Gate 7**, jump to Gate 8. User can run Gate 7 anytime with:

```bash
shared-assets/scripts/init-project/gate7.sh "${PROJECT}" "${FQDN}"
```

---

## Gate 7 — VPS via SSH from Mac (DNS + deploy)

**Runs on your Mac.** DNS hits Cloudflare API locally; everything else runs on the VPS over SSH. No Cursor session on the server.

**Only if Gate 1 was not `later`.** From monorepo root:

```bash
set -a && source ~/.cursor/secrets/monjizeen-dev.env && set +a
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/gate7.sh "${PROJECT}" "${FQDN}"
```

`gate7.sh` does:

1. **Local:** `dns.sh` → Cloudflare A record `{project}.mnjz.in` → `VPS_PUBLIC_IP`
2. **SSH:** rsync scripts to `VPS_SHARED_ASSETS_PATH/scripts/init-project/`
3. **SSH:** copy `~/.cursor/secrets/{project}.env` to VPS (for production `.env` merge)
4. **SSH:** `remote-setup.sh` on VPS — nginx vhost (exact `server_name` beats `*.mnjz.in` wildcard), certbot if needed, clone repo, build, migrate
5. **Local:** `verify.sh` over HTTPS

On first org setup, ensure VPS has `shared-assets` cloned:

```bash
ssh vps 'test -d /srv/projects/shared-assets/.git || git clone git@github.com:monjizeen-dev/shared-assets.git /srv/projects/shared-assets'
```

After merging skill changes to GitHub: `ssh vps 'cd /srv/projects/shared-assets && git pull'`

**Existing repo only** (e.g. kawader already on GitHub): skip Gates 2–3; run Gates 5–6 then `gate7.sh kawader kawader.mnjz.in`.

---

## Gate 8 — CI workflow

Add `.github/workflows/ci.yml` from [reference.md](reference.md#ci-workflow). Commit and push:

```bash
cd "${WORKSPACE}"
git add .github/workflows/ci.yml
git commit -m "chore: add CI workflow from shared-assets template"
git push
```

Remind user: GitHub repo needs `ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS` and Telegram secrets if notifications used (same as monjizeen).

---

## Gate 9 — Verify & handoff

**Local:**

```bash
cd "${WORKSPACE}"
php artisan test
```

**Production (if Gate 7 ran):**

```bash
shared-assets/scripts/init-project/verify.sh "${FQDN}"
```

Print handoff summary:

| Item | Value |
|------|-------|
| Repo | `https://github.com/monjizeen-dev/{PROJECT}` |
| URL | `https://{FQDN}` |
| Workspace | `{WORKSPACE}` |
| MORA agent | `domains/monjizeen-dev/agents/{PROJECT}/` |
| Secrets | `~/.cursor/secrets/{PROJECT}.env` |
| Deploy staging | push to `main` (if CI configured) |
| Deploy production | GitHub Actions `workflow_dispatch` |

Suggest: `remember that {PROJECT} lives at https://{FQDN}` if user uses MORA memory.

---

## Rules

- **Idempotent** — scripts safe to re-run; check before create.
- **Secrets** — never commit `.env`, never print client secret in chat after writing.
- **Pauses** — Gate 5 always waits for human; Gate 7 optional per Gate 1.
- **SSH** — Gate 7 never requires Cursor on VPS; Mac SSH only.
- **Multi-Mac** — same `~/.cursor/secrets/` values + skill symlink on each machine.
- **Scope** — do not modify unrelated repos. Do not init kawader unless user names it.
- **Executor** — run commands yourself; only Gates 1 and 5 need user input unless blocked.

## Additional resources

- [reference.md](reference.md) — templates, bootstrap, VPS handoff prompt
