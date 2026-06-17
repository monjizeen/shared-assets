# monjizeen-dev Shared Assets

Shared GitHub Actions workflows, composite actions, and Claude Code skills for all monjizeen-dev projects.

## Structure

```
actions/
  setup-flutter/     # Install Flutter SDK + pub get
  setup-laravel/     # Install PHP + Composer + prepare .env
  deploy-laravel/    # SSH deploy with artisan cache/migrate
  telegram-notify/   # Send Telegram status notification
.github/workflows/
  flutter-test.yml        # Reusable: format + analyze + test
  laravel-test.yml        # Reusable: pint + phpstan + migrate + test (SQLite)
  laravel-test-mysql.yml  # Reusable: same as above but with MySQL service
skills/
  (Claude Code / Cursor skills — see skills/README.md)
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
    uses: monjizeen-dev/shared-assets/.github/workflows/flutter-test.yml@main
    secrets: inherit

  deploy:
    needs: test
    # your project-specific deploy steps
```

### Laravel project (SQLite)

```yaml
jobs:
  test:
    uses: monjizeen-dev/shared-assets/.github/workflows/laravel-test.yml@main
    with:
      node-required: true  # if project has frontend assets
    secrets: inherit
```

### Laravel project (MySQL)

Use this when migrations have MySQL-specific syntax (raw SQL, composite keys, etc.)

```yaml
jobs:
  test:
    uses: monjizeen-dev/shared-assets/.github/workflows/laravel-test-mysql.yml@main
    secrets: inherit

  deploy-staging:
    needs: test
    steps:
      - uses: monjizeen-dev/shared-assets/actions/deploy-laravel@main
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
