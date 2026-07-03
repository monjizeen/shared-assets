---
name: new-project
description: >
  Unified new monjizeen-dev product setup — GitHub repo, scaffold, MORA registry,
  Google OAuth, mnjz.in subdomains, VPS deploy. Same flow on Cursor (Mac) and
  Telegram (VPS). Use when user says /new-project, new project, init project,
  set up project, or project initiation. Alias /init-project.
disable-model-invocation: true
---

# New Project

**One command:** `/new-project` — Cursor on Mac **or** Telegram on VPS. Same gates, same checklist.

Alias: `/init-project` (legacy name — identical flow).

Read [reference.md](../init-project/reference.md) for stack routing, CI, nginx, OAuth, agent stubs.

---

## Platform

Detect before Gate 0:

| Signal | Platform | CWD for commands |
|--------|----------|------------------|
| Cursor, `~/.cursor/mono-root` exists | **cursor** | `{MONO_ROOT}/mora` or `{MONO_ROOT}/{PROJECT}` |
| Telegram bot, `MORA_MONO_ROOT=/srv/projects` | **telegram** | `{MONO_ROOT}/mora` |

**Resolve `MONO_ROOT`:**

```bash
MONO_ROOT="$(cat ~/.cursor/mono-root 2>/dev/null | head -1)"
MONO_ROOT="${MONO_ROOT:-${MORA_MONO_ROOT:-$HOME/Documents/work/monjizeen-dev}}"
SHARED_ASSETS="${MONO_ROOT}/shared-assets"
MORA="${MONO_ROOT}/mora"
```

| Gate | Cursor (Mac) | Telegram (VPS) |
|------|--------------|----------------|
| 0 Bootstrap | `bootstrap-mac.sh` | `/sync all` + verify mora/shared-assets on disk |
| 1 Identity | Ask Omar (`AskQuestion` in Cursor) | Ask in chat — one question at a time |
| 2 GitHub | `gh repo create` on Mac | Same if `gh auth` on VPS; else tell Omar to auth or run on Mac |
| 3 Scaffold | `scaffold-web.sh` / `scaffold-expo.sh` on Mac | Prefer Mac; VPS scaffold only if Omar confirms |
| 4 MORA registry | Edit mora, sync-registry | Same — mora clone on VPS |
| 5 OAuth | **Manual** — pause for Omar | Collect creds via Telegram when ready |
| 6 Secrets | Write `~/.cursor/secrets/{project}.env` on Mac | **Mac required** for local secrets; VPS copies come in Gate 7 |
| 7 VPS DNS/nginx | `gate7.sh` from **Mac** (SSH → VPS) | Cannot run from VPS alone — Omar runs Gate 7 on Mac or says `skip vps` |
| 8–9 CI + verify | Mac or VPS with git push | Same |

**Telegram rules:** Never ask Omar to SSH manually. Run commands yourself on VPS. For Mac-only gates, state clearly what Omar must do on Mac or paste into Telegram.

**Work step by step.** At each **GATE**, collect required input, then continue. Never skip a gate. Never print secrets.

---

## Constants

| Key | Value |
|-----|-------|
| GitHub org | `monjizeen-dev` |
| Root domain | `mnjz.in` |
| Staging FQDN | `{project}-staging.mnjz.in` → auto-deploy on push to `main` (web only) |
| Production FQDN | `{project}.mnjz.in` → manual `workflow_dispatch` only (web only) |
| OAuth callbacks | `https://{project}-staging.mnjz.in/auth/google/callback`, `https://{project}.mnjz.in/auth/google/callback` |
| VPS deploy paths | `/srv/projects/{project}/staging`, `/srv/projects/{project}/production` |
| Org secrets file | `~/.cursor/secrets/monjizeen-dev.env` |
| Staging/local secrets | `~/.cursor/secrets/{project}.env` |
| Production secrets | `~/.cursor/secrets/{project}-production.env` |
| Web scaffold | `{SHARED_ASSETS}/templates/web-app` |
| Mobile scaffold | `{SHARED_ASSETS}/scripts/init-project/scaffold-expo.sh` |
| Init scripts | `{SHARED_ASSETS}/scripts/init-project/` |

**Do not scaffold from `kawader`.**

---

## Progress checklist

Copy and update after each gate:

```
New project: {project} ({PROJECT_TYPE})
- [ ] Gate 0 — Prerequisites
- [ ] Gate 1 — Project identity, stack, theme (web)
- [ ] Gate 2 — GitHub repo
- [ ] Gate 3 — Scaffold, tweakcn theme apply (web), first push
- [ ] Gate 4 — MORA registry + agent
- [ ] Gate 5 — Google OAuth (manual, web only)
- [ ] Gate 6 — Secrets on disk (web only)
- [ ] Gate 7 — VPS: DNS + nginx + deploy (web only, optional)
- [ ] Gate 8 — CI workflow
- [ ] Gate 9 — Verify & handoff
```

---

## Gate 0 — Bootstrap

### Cursor (Mac)

```bash
"${SHARED_ASSETS}/scripts/init-project/bootstrap-mac.sh"
```

Also valid: `/run-mora` then continue here.

### Telegram (VPS)

Pull latest hub repos:

```bash
cd "${MORA}" && git pull --ff-only
cd "${SHARED_ASSETS}" && git pull --ff-only
```

Verify org secrets on **Mac** exist before Gate 7 (Telegram can remind Omar).

Exit bootstrap **0** → Gate 1. Exit **1** → fix `need` items, re-run Gate 0.

---

## Gate 1 — Project identity & stack

**Ask Omar** (required):

1. **Project name** — lowercase kebab-case (e.g. `my-app`). Drives repo, subdomain, paths.
2. **One-line purpose** — for MORA `REGISTRY.yaml`.
3. **Project type** — `content` | `web-app` | `native-mobile` (see [reference.md — Stack routing](../init-project/reference.md#stack-routing)).
4. **Auth model** (web only) — `open` or `closed`.
5. **Design system** (web) — shadcn-vue + Lucide. Default yes.
6. **Theme** (web) — tweakcn URL or default `zinc`.
7. **Run VPS setup now?** (web only) — default `yes` on Mac if SSH ok; `later` skips Gate 7.

Validate name: `^[a-z][a-z0-9-]*[a-z0-9]$`, length 2–40, not reserved (`mora`, `shared-assets`, `kawader`).

Set: `PROJECT`, `PROJECT_TYPE`, `STACK`, `STAGING_FQDN`, `PRODUCTION_FQDN`, `REPO`, `WORKSPACE="${MONO_ROOT}/${PROJECT}"`, theme vars.

Confirm summary before Gate 2.

---

## Gate 2 — GitHub repo

```bash
cd "${MONO_ROOT}"
gh repo create "monjizeen-dev/${PROJECT}" --private --description "{purpose}" --confirm
```

If exists: `gh repo view monjizeen-dev/${PROJECT}` and continue.

---

## Gate 3 — Scaffold & first push

### Web

```bash
"${SHARED_ASSETS}/scripts/init-project/scaffold-web.sh" "${PROJECT}" "${MONO_ROOT}" "${AUTH_MODEL}"
cd "${WORKSPACE}"
git init && git branch -M main
```

Closed auth apps should redirect guests from `/` to `/login`; open apps keep the public home page. Customize README, `docs/ARCHITECTURE.md`. Apply tweakcn theme if not zinc (see init-project Gate 3).

### Expo

```bash
"${SHARED_ASSETS}/scripts/init-project/scaffold-expo.sh" "${PROJECT}"
cd "${WORKSPACE}"
git init && git branch -M main
```

### Initial commit (both)

```bash
find . \( -name '.DS_Store' -o -name '._*' \) -delete 2>/dev/null || true
git add -A
git commit -m "chore: initial scaffold for ${PROJECT}"
git remote add origin "git@github.com:monjizeen-dev/${PROJECT}.git" 2>/dev/null || true
git push -u origin main
```

---

## Gate 4 — MORA registry + agent

1. Edit `{MORA}/REGISTRY.yaml` — add repo + purpose.
2. Create `{MORA}/domains/monjizeen-dev/agents/{PROJECT}/SKILL.md` and `MEMORY.md` ([agent stub](../init-project/reference.md#agent-stub)).
3. `python3 "${MORA}/scripts/sync-registry.py"`
4. Commit mora when Omar asks.

---

## Gate 5 — Google OAuth (manual — web only)

**Skip for `native-mobile`** unless also standing up web API.

**Pause until Omar confirms OAuth client ready.** Show staging + production callback URLs. See [reference.md — Google links](../init-project/reference.md#google-links-quick-reference).

---

## Gate 6 — Secrets on disk (web only)

Write `~/.cursor/secrets/{PROJECT}.env` and `{PROJECT}-production.env`. Update local `.env`. Never commit secrets.

If Gate 1 VPS = `later`, skip Gate 7.

---

## Gate 7 — VPS (web only, from Mac)

```bash
set -a && source ~/.cursor/secrets/monjizeen-dev.env && set +a
"${SHARED_ASSETS}/scripts/init-project/gate7.sh" "${PROJECT}"
```

Creates `{PROJECT}-staging.mnjz.in` + `{PROJECT}.mnjz.in` (Cloudflare DNS, nginx, deploy dirs).

**Expo:** skip — document EAS path in handoff.

---

## Gate 8 — CI workflow

Add `.github/workflows/ci.yml` from [reference.md](../init-project/reference.md). Commit and push.

Web repos need GitHub secret `ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS`.

---

## Gate 9 — Verify & handoff

### Web

```bash
cd "${WORKSPACE}"
php artisan test
"${SHARED_ASSETS}/scripts/init-project/verify.sh" "${PROJECT}-staging.mnjz.in"
"${SHARED_ASSETS}/scripts/init-project/verify.sh" "${PROJECT}.mnjz.in"
```

### Handoff table

| Item | Web | Expo |
|------|-----|------|
| Repo | `github.com/monjizeen-dev/{PROJECT}` | same |
| Staging | `https://{PROJECT}-staging.mnjz.in` | N/A |
| Production | `https://{PROJECT}.mnjz.in` | App store / EAS |
| MORA agent | `domains/monjizeen-dev/agents/{PROJECT}/` | same |

---

## Rules

- **Idempotent** — scripts safe to re-run.
- **Secrets** — never commit `.env`; never print client secrets.
- **No kawader scaffold** — use `templates/web-app` only.
- **Pauses** — Gate 5 waits for human; Gate 7 optional per Gate 1.
- **Executor** — run commands yourself; Gates 1 and 5 need Omar input.
- **Resume** — Omar can say `/new-project continue {project}` to pick up at first incomplete gate.
