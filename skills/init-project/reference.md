# Init Project — Reference

## One-time bootstrap

Gate 0 runs `scripts/init-project/bootstrap-mac.sh` automatically. On a **new Mac**, you only need:

```bash
git clone git@github.com:monjizeen-dev/shared-assets.git ~/Documents/work/projects/monjizeen-dev/shared-assets
~/Documents/work/projects/monjizeen-dev/shared-assets/scripts/init-project/bootstrap-mac.sh
gh auth login   # if bootstrap reports gh not authenticated
```

Bootstrap will symlink the skill, create secrets dir, pull `monjizeen-dev.env` from VPS (or build from VPS Cloudflare config), append SSH `Host vps` if missing, and validate Cloudflare API.

**Requirements on new Mac:** SSH key accepted by VPS (`~/.ssh/id_ed25519` or update `~/.ssh/config`). Copy key from another Mac or `ssh-copy-id` once.

### Manual secrets file (fallback only)

If VPS is unreachable, create `~/.cursor/secrets/monjizeen-dev.env` on each Mac (chmod 600). Sync via 1Password/iCloud or copy from another Mac.

```bash
# https://dash.cloudflare.com/profile/api-tokens
CLOUDFLARE_API_TOKEN=
CLOUDFLARE_ZONE_ID=

VPS_PUBLIC_IP=187.77.109.160
VPS_SSH_HOST=vps
VPS_SSH_USER=root
VPS_SHARED_ASSETS_PATH=/srv/projects/shared-assets

CERTBOT_EMAIL=you@example.com
```

### Skill symlink

Handled by `bootstrap-mac.sh`. Manual equivalent:

```bash
ln -sf ~/Documents/work/projects/monjizeen-dev/shared-assets/skills/init-project \
  ~/.cursor/skills/init-project
```

### VPS: clone shared-assets (once)

```bash
ssh vps 'git clone git@github.com:monjizeen-dev/shared-assets.git /srv/projects/shared-assets 2>/dev/null || (cd /srv/projects/shared-assets && git pull)'
```

Gate 7 rsyncs latest scripts on every run; git pull keeps VPS copy current after merges.

### Cloudflare Zone ID

Dashboard → select **mnjz.in** → right sidebar **Zone ID**.

---

## Stack routing

Gate 1 **project type** selects scaffold and which later gates apply.

| `PROJECT_TYPE` | `STACK` | Template / script | Gates 5–7 (OAuth/VPS) | Design system |
|----------------|---------|-------------------|------------------------|---------------|
| `content` | `web` | `templates/web-app` + `scaffold-web.sh` | Yes | shadcn-vue + Lucide + tweakcn theme |
| `web-app` | `web` | `templates/web-app` + `scaffold-web.sh` | Yes | shadcn-vue + Lucide + tweakcn theme |
| `native-mobile` | `expo` | `scaffold-expo.sh` | **Skip** | Lucide RN + `constants/theme.ts` |

**Decision guide**

- Browser-only product, CMS, marketing, admin CRUD → `content` or `web-app` (same scaffold).
- Camera, push notifications, biometrics, app store, deep offline-native → `native-mobile` → Expo.
- Mobile app + Laravel API → init **two** repos (Expo + web) or add API later.

**Do not use `kawader` as init template.** Kawader is an existing talent-directory product.

### Maintainer: rebuild web template

After kawader OAuth shell or monjizeen UI primitives change:

```bash
shared-assets/scripts/init-project/build-web-app-template.sh
```

---

## Design system (web)

Org standard for all **web** scaffolds (`content`, `web-app`):

| Piece | Package / path |
|-------|----------------|
| Primitives | **shadcn-vue** (Reka UI, not Radix Vue) |
| Icons | **Lucide** — `lucide-vue-next` only |
| Styling | Tailwind CSS v4 + `resources/css/app-theme.css` (zinc tokens) |
| Utils | `resources/js/lib/utils.js` (`cn()` via clsx + tailwind-merge) |
| Components | `resources/js/components/ui/` |

**Shipped in template:** Button, Card, Input, Label, Separator.

**Add more components** (from project root after scaffold):

```bash
npx shadcn-vue@latest add dialog dropdown-menu select table
```

**Rules for agents**

- Import icons from `lucide-vue-next` only — no Heroicons, Font Awesome, or inline SVG sets.
- Use shadcn `Button`, `Card`, `Input`, etc. before bespoke styled elements.
- Match monjizeen patterns in `monjizeen/.cursor/rules/design.mdc` when building UI.

### tweakcn themes

Gate 1 asks user to pick a theme from [tweakcn community](https://tweakcn.com/community). Gate 3 applies it after scaffold (skip when user keeps default **zinc**).

| Gate 1 input | `THEME_NAME` | `THEME_URL` | Gate 3 action |
|--------------|--------------|-------------|---------------|
| Default zinc | `zinc` | *(empty)* | Skip — template `app-theme.css` already zinc |
| Community theme | name from tweakcn | `https://tweakcn.com/r/themes/{id}` | `shadcn-vue add` (below) |

**User flow:** open community → pick theme → copy install URL (format `https://tweakcn.com/r/themes/{id}`). Example:

```bash
npx shadcn-vue@latest add https://tweakcn.com/r/themes/cmmbmmxsb000104l5fqg5b4x3
```

Use **`shadcn-vue@latest`**, not React `shadcn@latest` — org web stack is Vue.

**CLI bootstrap** (when template lacks `components.json`):

`jsconfig.json` (project root):

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["resources/js/*"] }
  },
  "exclude": ["node_modules", "vendor"]
}
```

`components.json` (project root):

```json
{
  "$schema": "https://shadcn-vue.com/schema.json",
  "style": "new-york",
  "typescript": false,
  "tailwind": {
    "config": "",
    "css": "resources/css/app-theme.css",
    "baseColor": "zinc",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "composables": "@/composables"
  },
  "iconLibrary": "lucide"
}
```

Then from project root:

```bash
npx shadcn-vue@latest add "${THEME_URL}" -y
npm run build
```

CLI updates `resources/css/app-theme.css` (`:root`, `.dark`, `@theme inline`). Commit `components.json` and `jsconfig.json` with the scaffold when created.

Record `THEME_NAME` in README, agent `MEMORY.md`, and Gate 9 handoff.

### Design system (Expo)

- **Lucide:** `lucide-react-native` + `react-native-svg`
- **No shadcn** on React Native
- Shared tokens: `constants/theme.ts` (extend per product)
- Pair with Laravel API on mnjz.in when backend needed

---

## REGISTRY.yaml entry

Add under `domains.monjizeen-dev.repos`:

```yaml
      {PROJECT}:
        path: {PROJECT}
        agent: {PROJECT}
        purpose: {ONE_LINE_PURPOSE}
```

`start-work` / `finish-work` hooks apply to all `monjizeen-dev` repos via domain-level `inherit_hooks` in `REGISTRY.yaml`. Opt out per repo with `inherit_hooks: []`.

---

## Agent stub

### Web (`content` / `web-app`)

`mora/domains/monjizeen-dev/agents/{PROJECT}/SKILL.md`:

```markdown
---
name: {PROJECT}
description: >
  {PROJECT} agent. {ONE_LINE_PURPOSE}. Laravel + Inertia + Vue 3 + shadcn-vue + Lucide.
  Triggers on {PROJECT}. Not for other monjizeen-dev repos.
---

# {PROJECT} agent

## Scope

- **Domain:** monjizeen-dev
- **Repo:** `{PROJECT}/`
- **Workspace:** `~/Documents/work/projects/monjizeen-dev/{PROJECT}`

## Purpose

{ONE_LINE_PURPOSE}

## Stack

- Laravel 13, PHP 8.3+, SQLite (dev/CI)
- Inertia.js + Vue 3, Tailwind CSS v4, Vite
- Design system: shadcn-vue (Reka UI) + Lucide icons
- Theme: {THEME_NAME} (tweakcn or zinc default)
- Google OAuth (Socialite), session guard

## Memory

`domains/monjizeen-dev/agents/{PROJECT}/MEMORY.md`
```

`MEMORY.md` (web):

```markdown
# {PROJECT} — agent memory

## Decisions

- Project type: {PROJECT_TYPE}
- Stack: Laravel + Inertia + Vue 3, shadcn-vue + Lucide, Google OAuth
- Theme: {THEME_NAME} ({THEME_URL} or template zinc)
- Staging URL: https://staging-{PROJECT}.mnjz.in
- Production URL: https://app-{PROJECT}.mnjz.in

## Open questions

*(Empty — populate with `remember that …`)*
```

### Expo (`native-mobile`)

`SKILL.md` excerpt:

```markdown
## Stack

- Expo (React Native) + TypeScript
- Icons: lucide-react-native
- Backend API: (TBD — Laravel on mnjz.in if needed)
```

`MEMORY.md` (expo):

```markdown
# {PROJECT} — agent memory

## Decisions

- Project type: native-mobile
- Stack: Expo + TypeScript, Lucide icons
- No mnjz.in VPS deploy — EAS / app store release path

## Open questions

*(Empty)*
```

---

## CI workflow

`.github/workflows/ci.yml` in the new repo:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
    inputs:
      deploy_target:
        description: 'Deploy target (leave empty to just run tests)'
        required: false
        type: choice
        options:
          - staging
          - production

jobs:
  test:
    uses: monjizeen-dev/shared-assets/.github/workflows/laravel-test.yml@main
    with:
      node-required: true
    secrets: inherit

  deploy-staging:
    needs: test
    runs-on: self-hosted
    if: |
      (github.ref == 'refs/heads/main' && github.event_name == 'push') ||
      (github.event_name == 'workflow_dispatch' && github.event.inputs.deploy_target == 'staging')
    steps:
      - uses: actions/checkout@v4.2.2
      - uses: monjizeen-dev/shared-assets/actions/deploy-laravel@main
        with:
          host: 127.0.0.1
          username: www-data
          ssh-key: ${{ secrets.ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS }}
          deploy-path: /srv/projects/{PROJECT}/staging
          local: "true"
          pre-commands: |
            DEPLOY_USER="$(whoami)"
            DEPLOY_GROUP="$(id -gn)"
            sudo chown -R "${DEPLOY_USER}:${DEPLOY_GROUP}" .git 2>/dev/null || true
            chmod -R u+w .git 2>/dev/null || true
            chmod -R u+w . 2>/dev/null || true
          extra-commands: |
            npm ci
            npm run build

  deploy-production:
    needs: test
    runs-on: self-hosted
    if: github.event_name == 'workflow_dispatch' && github.event.inputs.deploy_target == 'production'
    steps:
      - uses: actions/checkout@v4.2.2
      - uses: monjizeen-dev/shared-assets/actions/deploy-laravel@main
        with:
          host: 127.0.0.1
          username: www-data
          ssh-key: ${{ secrets.ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS }}
          deploy-path: /srv/projects/{PROJECT}/production
          local: "true"
          pre-commands: |
            DEPLOY_USER="$(whoami)"
            DEPLOY_GROUP="$(id -gn)"
            sudo chown -R "${DEPLOY_USER}:${DEPLOY_GROUP}" .git 2>/dev/null || true
            chmod -R u+w .git 2>/dev/null || true
            chmod -R u+w . 2>/dev/null || true
          extra-commands: |
            npm ci
            npm run build
```

Replace `{PROJECT}` with the actual project name.

**Deploy targets:** `deploy-staging` pushes to `/srv/projects/{PROJECT}/staging` (served at `staging-{PROJECT}.mnjz.in`). `deploy-production` is `workflow_dispatch` only → `/srv/projects/{PROJECT}/production` (`app-{PROJECT}.mnjz.in`). Push to `main` / auto-merge only hits staging.

---

## Expo CI workflow

`.github/workflows/ci.yml` for Expo repos:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4.2.2
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: npm
      - run: npm ci
      - run: npx tsc --noEmit
```

Add EAS Build workflow separately when the product is ready for store releases.

---

## nginx vhost template

Used by `scripts/init-project/nginx-vhost.sh`. Gate 7 creates **two** vhosts per project:

| FQDN | nginx root |
|------|------------|
| `staging-{PROJECT}.mnjz.in` | `/srv/projects/{PROJECT}/staging/public` |
| `app-{PROJECT}.mnjz.in` | `/srv/projects/{PROJECT}/production/public` |

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name {FQDN};
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name {FQDN};

    root /srv/projects/{PROJECT}/{DEPLOY_ENV}/public;
    index index.php;

    # SSL: Cloudflare origin cert or Let's Encrypt — adjust paths on your VPS
    ssl_certificate     /etc/ssl/cloudflare/mnjz.in.pem;
    ssl_certificate_key /etc/ssl/cloudflare/mnjz.in.key;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_hide_header X-Powered-By;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

**Note:** SSL paths and PHP socket vary per VPS. Agent should inspect existing vhosts (e.g. monjizeen) and match conventions before writing.

---

## .env.example Google block

```env
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI="${APP_URL}/auth/google/callback"
PLATFORM_ADMIN_EMAILS=
```

Production `APP_URL` (set by `env-deploy.sh` on VPS):

```env
# staging .env  ← secrets from ~/.cursor/secrets/{PROJECT}.env
APP_URL=https://staging-{PROJECT}.mnjz.in

# production .env  ← secrets from ~/.cursor/secrets/{PROJECT}-production.env
APP_URL=https://app-{PROJECT}.mnjz.in
```

### OAuth secrets (two Google clients)

| File | Used for | Google OAuth client |
|------|----------|---------------------|
| `~/.cursor/secrets/{PROJECT}.env` | Local dev + staging VPS | Staging/local client (`staging-{PROJECT}.mnjz.in` + `127.0.0.1:8000`) |
| `~/.cursor/secrets/{PROJECT}-production.env` | Production VPS only | Production client (`app-{PROJECT}.mnjz.in`) |

Gate 7 syncs both files to VPS `~/.cursor/secrets/`. `env-deploy.sh` selects the file by deploy target.

---

## Gate 7 only (existing repo)

Mac, after Gate 5–6:

```bash
source ~/.cursor/secrets/monjizeen-dev.env
shared-assets/scripts/init-project/gate7.sh {PROJECT}
```

Creates DNS + nginx for `staging-{PROJECT}.mnjz.in` and `app-{PROJECT}.mnjz.in`.

---

## nginx note (this VPS)

`*.mnjz.in` wildcard vhost proxies to OpenClaw. Per-app vhosts use **exact** `server_name` (e.g. `staging-kawader.mnjz.in`, `app-kawader.mnjz.in`) and take precedence. Each FQDN needs its own Let's Encrypt cert (`CERTBOT_EMAIL` + certbot in `remote-setup.sh`).

---

## gitignore

Gate 3: after scaffold from `templates/web-app`, ensure project `.gitignore` includes these (merge if missing — do not replace Laravel defaults):

```gitignore
# OS junk
**/.DS_Store
.DS_Store
._*
.AppleDouble
.LSOverride
Thumbs.db
ehthumbs.db
Desktop.ini
```

`web-app` template should already carry most of this; `**/.DS_Store` and `._*` catch nested Finder droppings.

---

## Google links (quick reference)

| Step | URL |
|------|-----|
| Consent screen | https://console.cloud.google.com/apis/credentials/consent |
| Credentials list | https://console.cloud.google.com/apis/credentials |
| Create Web client | https://console.cloud.google.com/apis/credentials/oauthclient |
