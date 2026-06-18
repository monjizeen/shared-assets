---
name: init-project
description: >
  Step-by-step monjizeen-dev project initiation: project-type stack routing
  (web vs Expo), GitHub repo, scaffold, shadcn-vue + Lucide design system,
  MORA registry, Google OAuth, mnjz.in subdomain, VPS deploy. Pauses for manual
  inputs at each gate. Use when user says init project, new project, set up
  project, project initiation, or /init-project.
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
| Staging FQDN | `staging-{project}.mnjz.in` → auto-deploy on push to `main` (web only) |
| Production FQDN | `app-{project}.mnjz.in` → manual `workflow_dispatch` only (web only) |
| OAuth callbacks | `https://staging-{project}.mnjz.in/auth/google/callback`, `https://app-{project}.mnjz.in/auth/google/callback` |
| VPS deploy paths | `/srv/projects/{project}/staging`, `/srv/projects/{project}/production` |
| Org secrets file | `~/.cursor/secrets/monjizeen-dev.env` |
| Staging/local secrets | `~/.cursor/secrets/{project}.env` (local dev + staging VPS) |
| Production secrets | `~/.cursor/secrets/{project}-production.env` |
| Web scaffold template | `shared-assets/templates/web-app` (Laravel + Inertia + Vue 3 + shadcn-vue + Lucide) |
| Mobile scaffold | `shared-assets/scripts/init-project/scaffold-expo.sh` (Expo + TypeScript + Lucide) |
| Init scripts | `shared-assets/scripts/init-project/` |

**Do not scaffold from `kawader`** — kawader is an existing product repo, not the org init template.

Read [reference.md](reference.md) for stack routing, design system, CI, nginx, REGISTRY, agent stub.

---

## Progress checklist

Copy and update after each gate:

```
Init project: {project} ({PROJECT_TYPE})
- [ ] Gate 0 — Prerequisites
- [ ] Gate 1 — Project identity & stack
- [ ] Gate 2 — GitHub repo
- [ ] Gate 3 — Scaffold & first push
- [ ] Gate 4 — MORA registry + agent
- [ ] Gate 5 — Google OAuth (manual, web only)
- [ ] Gate 6 — Secrets on disk (web only)
- [ ] Gate 7 — VPS: DNS + nginx + deploy (web only, optional)
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

If bootstrap exits **0** → continue to Gate 1.  
If exit **1** → fix `need` items, re-run bootstrap.

After bootstrap, verify org secrets exist (do not print values):

```bash
test -f ~/.cursor/secrets/monjizeen-dev.env && echo "org secrets: ok"
```

See [reference.md — One-time bootstrap](reference.md#one-time-bootstrap) for new-Mac setup.

---

## Gate 1 — Project identity & stack

**Ask the user** (required):

1. **Project name** — lowercase kebab-case (e.g. `my-app`). Drives repo name, subdomain, paths.
2. **One-line purpose** — for MORA `REGISTRY.yaml`.
3. **Project type** — picks stack (see [reference.md — Stack routing](reference.md#stack-routing)):

| Answer | When to use | Stack |
|--------|-------------|-------|
| `content` | Marketing sites, blogs, mostly static/CRUD content in browser | Web (`templates/web-app`) |
| `web-app` | Interactive web product, dashboards, no native device APIs | Web (`templates/web-app`) |
| `native-mobile` | Needs native device features (camera, push, offline, app store, biometrics) | **Expo** (`scaffold-expo.sh`) |

If unsure between `content` and `web-app`, default **`web-app`**.  
If user mentions app store, push notifications, camera, or offline-native → **`native-mobile`**.

4. **Auth model** (web only) — `open` (auto-create users on Google sign-in) or `closed` (only existing users/admins, like monjizeen). Skip for `native-mobile` unless they also want a web API (init web separately).
5. **Design system** (web only) — confirm org standard: **shadcn-vue** (Reka UI primitives) + **Lucide** (`lucide-vue-next`). Default **yes**; template ships with Button, Card, Input, Label, Separator + zinc theme tokens. User can add components later via `npx shadcn-vue@latest add <name>`.
6. **Run VPS setup now?** (web only) — default `yes` if SSH preflight passes; `later` skips Gate 7.

Validate project name: `^[a-z][a-z0-9-]*[a-z0-9]$`, length 2–40, not reserved (`mora`, `shared-assets`, `kawader`).

Set for the rest of the run:

- `PROJECT` = name
- `PROJECT_TYPE` = `content` | `web-app` | `native-mobile`
- `STACK` = `web` | `expo`
- `STAGING_FQDN` = `staging-{PROJECT}.mnjz.in` (web)
- `PRODUCTION_FQDN` = `app-{PROJECT}.mnjz.in` (web)
- `REPO` = `monjizeen-dev/{PROJECT}`
- `WORKSPACE` = `~/Documents/work/projects/monjizeen-dev/{PROJECT}`

Confirm summary with user before Gate 2.

---

## Gate 2 — GitHub repo

```bash
cd ~/Documents/work/projects/monjizeen-dev
gh repo create "monjizeen-dev/${PROJECT}" --private --description "{purpose}" --confirm
```

If repo already exists, `gh repo view monjizeen-dev/${PROJECT}` and continue.

---

## Gate 3 — Scaffold & first push

### Web (`content` or `web-app`)

**Never rsync from `kawader`.** Use the org web template:

```bash
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/scaffold-web.sh "${PROJECT}"
cd "${WORKSPACE}"
git init
git branch -M main
```

If `templates/web-app` is missing, run `build-web-app-template.sh` first (maintainer).

Then customize (agent does this):

1. `README.md` — project purpose + local setup + design system note (shadcn-vue + Lucide).
2. `docs/ARCHITECTURE.md` — title, purpose; keep stack/layering/design-system sections.
3. If auth model is `closed`, note in README that sign-in matches monjizeen allowlist pattern.
4. If `content`, simplify dashboard copy; stack stays the same.

```bash
php artisan test || true
```

### Expo (`native-mobile`)

```bash
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/scaffold-expo.sh "${PROJECT}"
cd "${WORKSPACE}"
git init
git branch -M main
npm test 2>/dev/null || true
```

Expo scaffold includes `lucide-react-native`, `constants/theme.ts`, and `docs/ARCHITECTURE.md`. No shadcn on mobile.

### Initial commit (both stacks)

```bash
find . \( -name '.DS_Store' -o -name '._*' -o -name 'Thumbs.db' -o -name 'Desktop.ini' \) -delete 2>/dev/null || true
git add -A
git commit -m "$(cat <<EOF
chore: initial scaffold for ${PROJECT}

${PROJECT_TYPE} stack from org init-project template.
EOF
)"
git remote add origin "git@github.com:monjizeen-dev/${PROJECT}.git" 2>/dev/null || true
git push -u origin main
```

---

## Gate 4 — MORA registry + agent

1. Edit `mora/REGISTRY.yaml` — add repo (include `purpose`; note stack in agent memory).
2. Create `mora/domains/monjizeen-dev/agents/{PROJECT}/SKILL.md` and `MEMORY.md` using [reference.md — Agent stub](reference.md#agent-stub) for the correct stack.
3. Regenerate JSON:

```bash
cd ~/Documents/work/projects/monjizeen-dev/mora
python3 scripts/sync-registry.py
```

Commit in `mora` only if user asked.

---

## Gate 5 — Google OAuth (manual — web only)

**Skip entirely for `native-mobile`** unless user is also standing up a web API (second init or add Laravel later).

**Do not continue until user confirms OAuth client is created and creds are ready.**

Show OAuth block from previous skill version (fill `{PROJECT}`, `{STAGING_FQDN}`, `{PRODUCTION_FQDN}`). See [reference.md — Google links](reference.md#google-links-quick-reference).

---

## Gate 6 — Secrets on disk (web only)

Write staging/local and production secrets files. Update local `.env` from staging secrets. See previous gate-6 instructions in git history or reference.md OAuth section.

If Gate 1 VPS answer was `later`, skip Gate 7.

---

## Gate 7 — VPS (web only)

```bash
set -a && source ~/.cursor/secrets/monjizeen-dev.env && set +a
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/gate7.sh "${PROJECT}"
```

**Expo:** skip — mobile builds via EAS / app stores, not mnjz.in Laravel VPS paths. Document in handoff.

**Existing web repo only:** skip Gates 2–3; run Gates 5–6 then `gate7.sh {PROJECT}`.

---

## Gate 8 — CI workflow

### Web

Add `.github/workflows/ci.yml` from [reference.md — CI workflow](reference.md#ci-workflow). Commit and push.

### Expo

Add `.github/workflows/ci.yml` from [reference.md — Expo CI](reference.md#expo-ci-workflow). Commit and push.

Remind user: web repos need `ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS` on GitHub (same as monjizeen).

---

## Gate 9 — Verify & handoff

### Web

```bash
cd "${WORKSPACE}"
php artisan test
# if Gate 7 ran:
shared-assets/scripts/init-project/verify.sh "staging-${PROJECT}.mnjz.in"
shared-assets/scripts/init-project/verify.sh "app-${PROJECT}.mnjz.in"
```

### Expo

```bash
cd "${WORKSPACE}"
npx expo export --platform web 2>/dev/null || npx tsc --noEmit 2>/dev/null || true
```

Print handoff summary:

| Item | Web | Expo |
|------|-----|------|
| Repo | `https://github.com/monjizeen-dev/{PROJECT}` | same |
| Staging URL | `https://staging-{PROJECT}.mnjz.in` | N/A (use EAS) |
| Production URL | `https://app-{PROJECT}.mnjz.in` | App store / EAS |
| Workspace | `{WORKSPACE}` | same |
| MORA agent | `domains/monjizeen-dev/agents/{PROJECT}/` | same |
| Design system | shadcn-vue + `lucide-vue-next` | Lucide RN + `constants/theme.ts` |
| Stack | Laravel + Inertia + Vue 3 | Expo + TypeScript |

---

## Rules

- **Idempotent** — scripts safe to re-run.
- **Secrets** — never commit `.env`, never print client secrets after writing.
- **No kawader scaffold** — use `templates/web-app` only. Kawader is a product, not init template.
- **Stack routing** — Gate 1 `native-mobile` → Expo; otherwise web template.
- **Design system** — web: shadcn-vue + Lucide; mobile: Lucide only (no shadcn).
- **Pauses** — Gate 5 waits for human (web); Gate 7 optional per Gate 1.
- **Scope** — do not modify unrelated repos.
- **Executor** — run commands yourself; Gates 1 and 5 need user input unless blocked.

## Additional resources

- [reference.md](reference.md) — stack matrix, design system, CI, templates, bootstrap
