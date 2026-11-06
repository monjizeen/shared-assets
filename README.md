# monjizeen Shared Assets

Shared GitHub Actions workflows, composite actions, and Claude Code skills for all monjizeen projects.

## AI workforce: Maharat, Adwar, Masarat

Monjizeen's AI workforce is written down in three layers, kept as folders in
this one repo so a rename or change lands in one place:

| Layer | Folder | Holds |
|---|---|---|
| Maharat (مهارات) | [`skills/`](skills/) | One skill per job: inputs, method, outputs, limits, checks |
| Adwar (أدوار) | [`roles/`](roles/) | One agent per role: mission, duties, boundaries, which skills it uses, decision rules |
| Masarat (مسارات) | [`workflows/`](workflows/) | How roles work together: who starts, who hands off to whom, where Omar approves |

Rules and quality checks every task gets stay in `monjizeen/monjizeen-core`.
A layer moves to its own repo only if different people own it, someone outside
needs it on its own, or it changes at a very different pace.

The Arabic names are labels. Folder names stay in English because AI tools
look for `skills/`, and "Maharat" alone also names Scout's list of 50 freelance
skills.

## Structure

```
packages/
  design-system/     # redirect — canonical package in github.com/monjizeen/enjaz
actions/
  setup-flutter/     # Install Flutter SDK + pub get
  setup-laravel/     # Install PHP + Composer + prepare .env
  deploy-laravel/    # SSH deploy with artisan cache/migrate
  deploy-service/    # VPS deploy for non-Laravel apps: pull, build, restart systemd service
  telegram-notify/   # Telegram status alert (switched off for now: ALERTS_ON in action.yml)
.github/workflows/
  flutter-test.yml        # Reusable: format + analyze + test
  laravel-test.yml        # Reusable: pint + phpstan + migrate + test (SQLite)
  laravel-test-mysql.yml  # Reusable: same as above but with MySQL service
skills/              # Maharat (مهارات): what each skill does — see skills/README.md
roles/               # Adwar (أدوار): each agent's mission, limits, decisions — see roles/README.md
workflows/           # Masarat (مسارات): how agents hand work to each other — see workflows/README.md
clients/
  <client>/STATUS.md  # each client project's status, read by the main CEO project
scripts/
  init-project/
    bootstrap-mac.sh  # New Mac: skill symlink + secrets from VPS
    dns.sh          # Cloudflare A record (runs on Mac)
    gate7.sh        # Mac orchestrator: DNS + SSH remote setup
    remote-setup.sh # Runs on VPS via SSH
    nginx-vhost.sh  # Per-app vhost (beats *.mnjz.in wildcard)
    env-production.sh
    verify.sh
```

## Usage

### Flutter project

```yaml
jobs:
  test:
    uses: monjizeen/shared-assets/.github/workflows/flutter-test.yml@main
    secrets: inherit

  deploy:
    needs: test
    # your project-specific deploy steps
```

### Laravel project (SQLite)

```yaml
jobs:
  test:
    uses: monjizeen/shared-assets/.github/workflows/laravel-test.yml@main
    with:
      node-required: true  # if project has frontend assets
    secrets: inherit
```

### Laravel project (MySQL)

Use this when migrations have MySQL-specific syntax (raw SQL, composite keys, etc.)

```yaml
jobs:
  test:
    uses: monjizeen/shared-assets/.github/workflows/laravel-test-mysql.yml@main
    secrets: inherit

  deploy-staging:
    needs: test
    steps:
      - uses: monjizeen/shared-assets/actions/deploy-laravel@main
        with:
          host: 187.77.109.160
          username: www-data
          ssh-key: ${{ secrets.SSH_KEY }}
          deploy-path: /srv/projects/myapp/staging
```

## Design principles

- **Different tech stack = separate workflow** (flutter-test vs laravel-test)
- **Shared functionality = reusable action** (setup, deploy, notifications)
- **No mega-workflows** — each project has a thin caller CI that composes what it needs

## Design system

**`@enjaz/design-system`** lives in the [**enjaz**](https://github.com/monjizeen/enjaz) repo. Live gallery: https://enjaz.mnjz.in

Pattern docs: [enjaz/packages/design-system/docs/INDEX.md](https://github.com/monjizeen/enjaz/blob/main/packages/design-system/docs/INDEX.md)

Sync from monjizeen: `cd enjaz/packages/design-system && npm run sync`
