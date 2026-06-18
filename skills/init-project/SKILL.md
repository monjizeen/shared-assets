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
| Staging FQDN | `staging-{project}.mnjz.in` → auto-deploy on push to `main` |
| Production FQDN | `app-{project}.mnjz.in` → manual `workflow_dispatch` only |
| OAuth callbacks | `https://staging-{project}.mnjz.in/auth/google/callback`, `https://app-{project}.mnjz.in/auth/google/callback` |
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

## Gate 0 — Mac bootstrap (run first, every time)

**Always run bootstrap before anything else.** It calls **`refresh-mora`** (pull repos, install hooks, symlink skills), then secrets/SSH/tools.

```bash
shared-assets/scripts/init-project/bootstrap-mac.sh
```

Daily sync without starting a new project:

```bash
mora/scripts/refresh-mora.sh
# or in Cursor: /refresh-mora
```

`bootstrap-mac.sh` checks and **fixes when possible**:

| Check | Auto-fix |
|-------|----------|
| `shared-assets` + `mora` git pull | Yes — via `refresh-mora.sh` |
| `~/.cursor` hooks/rules symlinks | Yes — `install-cursor-runtime.sh` |
| `~/.cursor/skills/refresh-mora` + `init-project` | Yes |
| `shared-assets` clone | No — prints `git clone` if bootstrap cannot find repo |
| `~/.cursor/secrets/` directory | Yes |
| `~/.cursor/secrets/monjizeen-dev.env` | Yes — `scp` from VPS, or build from VPS `cloudflare.ini` |
| `~/.ssh/config` Host `vps` | Yes — appends template if missing |
| `~/.zshrc` sources org secrets | Yes — adds line if missing |
| `gh`, `git`, `ssh`, `curl`, `python3`, `jq` | No — prints install hint |
| `gh auth login` | No — user runs once |
| SSH to VPS | No — needs SSH key on this Mac |
| Cloudflare API | Validates token; no print of secrets |

If bootstrap exits **0** → continue to Gate 1.  
If exit **1** → fix `need` items, re-run bootstrap. **Do not ask user to manually symlink or copy secrets if bootstrap can still fix them.**

After bootstrap, verify (agent may run — do not print secret values):

```bash
test -f ~/.cursor/secrets/monjizeen-dev.env && echo "org secrets: ok"
```

Required keys in `~/.cursor/secrets/monjizeen-dev.env`:

- `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ZONE_ID`, `VPS_PUBLIC_IP`
- `VPS_SSH_HOST` (default `vps`), `VPS_SSH_USER` (default `root`)
- `CERTBOT_EMAIL`, `VPS_SHARED_ASSETS_PATH` (optional)

### New Mac quick start (human)

```bash
git clone git@github.com:monjizeen-dev/shared-assets.git ~/Documents/work/projects/monjizeen-dev/shared-assets
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/bootstrap-mac.sh
```

Then in Cursor: `/init-project` (new project) or `/refresh-mora` (sync only).

Manual fallback only if bootstrap cannot SSH to VPS: copy `~/.cursor/secrets/monjizeen-dev.env` from another Mac. See [reference.md — One-time bootstrap](reference.md#one-time-bootstrap).

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
- `STAGING_FQDN` = `staging-{PROJECT}.mnjz.in`
- `PRODUCTION_FQDN` = `app-{PROJECT}.mnjz.in`
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

Show this block verbatim (fill `{PROJECT}`, `{STAGING_FQDN}`, `{PRODUCTION_FQDN}`):

---

### Google OAuth setup for `{PROJECT}`

**1. OAuth consent screen** (once per GCP project, skip if already done)

- Open: https://console.cloud.google.com/apis/credentials/consent
- User type: External (or Internal if Google Workspace)
- Add authorized domain: `mnjz.in`

**2. Create OAuth client** (one per app — do this now)

- Open: https://console.cloud.google.com/apis/credentials/oauthclient
- Application type: **Web application**
- Name: `{PROJECT}` (or similar)
- **Authorized JavaScript origins:**
  - `https://{STAGING_FQDN}`
  - `https://{PRODUCTION_FQDN}`
- **Authorized redirect URIs:**
  - `https://{STAGING_FQDN}/auth/google/callback`
  - `https://{PRODUCTION_FQDN}/auth/google/callback`
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
shared-assets/scripts/init-project/gate7.sh "${PROJECT}"
```

---

## Gate 7 — VPS via SSH from Mac (DNS + deploy)

**Runs on your Mac.** DNS hits Cloudflare API locally; everything else runs on the VPS over SSH. No Cursor session on the server.

**Only if Gate 1 was not `later`.** From monorepo root:

```bash
set -a && source ~/.cursor/secrets/monjizeen-dev.env && set +a
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/gate7.sh "${PROJECT}"
```

`gate7.sh` does:

1. **Local:** `dns.sh` → Cloudflare A records `staging-{project}.mnjz.in` and `app-{project}.mnjz.in` → `VPS_PUBLIC_IP`
2. **SSH:** rsync scripts to `VPS_SHARED_ASSETS_PATH/scripts/init-project/`
3. **SSH:** copy `~/.cursor/secrets/{project}.env` to VPS (for staging + production `.env` merge)
4. **SSH:** `remote-setup.sh` on VPS — nginx vhosts (staging → `/staging/public`, production → `/production/public`), certbot if needed, clone repo to both paths, build, migrate
5. **Local:** `verify.sh` for staging and production HTTPS + OAuth

On first org setup, ensure VPS has `shared-assets` cloned:

```bash
ssh vps 'test -d /srv/projects/shared-assets/.git || git clone git@github.com:monjizeen-dev/shared-assets.git /srv/projects/shared-assets'
```

After merging skill changes to GitHub: `ssh vps 'cd /srv/projects/shared-assets && git pull'`

**Existing repo only** (e.g. kawader already on GitHub): skip Gates 2–3; run Gates 5–6 then `gate7.sh kawader`.

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

**Remote (if Gate 7 ran):**

```bash
shared-assets/scripts/init-project/verify.sh "staging-{PROJECT}.mnjz.in"
shared-assets/scripts/init-project/verify.sh "app-{PROJECT}.mnjz.in"
```

Print handoff summary:

| Item | Value |
|------|-------|
| Repo | `https://github.com/monjizeen-dev/{PROJECT}` |
| Staging URL | `https://staging-{PROJECT}.mnjz.in` (auto on push to `main`) |
| Production URL | `https://app-{PROJECT}.mnjz.in` (manual deploy only) |
| Workspace | `{WORKSPACE}` |
| MORA agent | `domains/monjizeen-dev/agents/{PROJECT}/` |
| Secrets | `~/.cursor/secrets/{PROJECT}.env` |
| Deploy staging | push to `main` / auto-merge → CI deploys staging |
| Deploy production | GitHub Actions `workflow_dispatch` → production |

Suggest: `remember that {PROJECT} staging is https://staging-{PROJECT}.mnjz.in and production is https://app-{PROJECT}.mnjz.in` if user uses MORA memory.

---

## Rules

- **Idempotent** — scripts safe to re-run; check before create.
- **Secrets** — never commit `.env`, never print client secret in chat after writing.
- **Pauses** — Gate 5 always waits for human; Gate 7 optional per Gate 1.
- **SSH** — Gate 7 never requires Cursor on VPS; Mac SSH only.
- **Bootstrap** — Gate 0 always runs `bootstrap-mac.sh` first; prefer auto-fix over manual steps.
- **Scope** — do not modify unrelated repos. Do not init kawader unless user names it.
- **Executor** — run commands yourself; only Gates 1 and 5 need user input unless blocked.

## Additional resources

- [reference.md](reference.md) — templates, bootstrap, VPS handoff prompt
