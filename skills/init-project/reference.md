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

## REGISTRY.yaml entry

Add under `domains.monjizeen-dev.repos`:

```yaml
      {PROJECT}:
        path: {PROJECT}
        agent: {PROJECT}
        purpose: {ONE_LINE_PURPOSE}
        inherit_hooks: [start-work, finish-work]
```

---

## Agent stub

`mora/domains/monjizeen-dev/agents/{PROJECT}/SKILL.md`:

```markdown
---
name: {PROJECT}
description: >
  {PROJECT} agent. {ONE_LINE_PURPOSE}. Laravel + Inertia + Vue 3.
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
- Google OAuth (Socialite), session guard

## Memory

`domains/monjizeen-dev/agents/{PROJECT}/MEMORY.md`
```

`MEMORY.md`:

```markdown
# {PROJECT} — agent memory

## Decisions

- Stack: Laravel + Inertia + Vue 3, Google OAuth only
- Production URL: https://{PROJECT}.mnjz.in

## Open questions

*(Empty — populate with `remember that …`)*
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

---

## nginx vhost template

Used by `scripts/init-project/nginx-vhost.sh`:

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

    root /srv/projects/{PROJECT}/production/public;
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

Production `APP_URL`:

```env
APP_URL=https://{PROJECT}.mnjz.in
```

---

## Gate 7 only (existing repo)

Mac, after Gate 5–6:

```bash
source ~/.cursor/secrets/monjizeen-dev.env
shared-assets/scripts/init-project/gate7.sh {PROJECT} {PROJECT}.mnjz.in
```

---

## nginx note (this VPS)

`*.mnjz.in` wildcard vhost proxies to OpenClaw. Per-app vhosts use **exact** `server_name` (e.g. `kawader.mnjz.in`) and take precedence. Each app needs its own Let's Encrypt cert (`CERTBOT_EMAIL` + certbot in `remote-setup.sh`).

---

## Google links (quick reference)

| Step | URL |
|------|-----|
| Consent screen | https://console.cloud.google.com/apis/credentials/consent |
| Credentials list | https://console.cloud.google.com/apis/credentials |
| Create Web client | https://console.cloud.google.com/apis/credentials/oauthclient |
