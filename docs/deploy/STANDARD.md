# How Monjizeen projects deploy

One standard, so every repo looks the same. New projects get it from
`/new-project` (Gate 8); the workflow text lives in
`skills/init-project/reference.md`.

## Where the code goes

| Kind of project | Deploys with | Runs on | Example |
|-----------------|--------------|---------|---------|
| Laravel web app | `actions/deploy-laravel` (`local: "true"`) | the VPS, its own self-hosted runner | monjizeen-app, monjizeen-site |
| Background service (Node, Python…) | `actions/deploy-service` | the VPS, its own self-hosted runner | radar |
| Static site on Cloudflare | `wrangler deploy` | GitHub's machines (`ubuntu-latest`) | monjizeen-business |
| Chrome extension | release workflow + Chrome Web Store script | GitHub's machines | monjizeen-extension |
| Library / no server | tests only | GitHub's machines | monjizeen-core |

## Rules for VPS deploys

1. **One runner per repo** on the VPS: folder `/srv/github-actions-runner-{project}`,
   name `<hostname>-{project}`. Never copy another runner's folder. Without
   its own runner a deploy waits about a day and is then cancelled.
2. Code lives in `/srv/projects/{project}` (Laravel: `…/staging`, `…/production`),
   owned by `www-data`.
3. Tests run on GitHub's machines; only the deploy job uses `runs-on: self-hosted`.
4. Push to `main` deploys staging (or the only copy). Production is a manual
   "Run workflow" when the project has one.
5. Every deploy job has Telegram alert steps (`actions/telegram-notify`).
   Alerts are **switched off** for now (Omar, 2026-11-01): one setting,
   `ALERTS_ON` in `actions/telegram-notify/action.yml`, turns them back on
   for every repo.
6. Secrets: `ACCESS_TO_VPS_WWWDATA_FROM_GITHUB_ACTIONS` (Laravel),
   `TELEGRAM_NOTIFIER_TOKEN`, `TELEGRAM_CHANNEL_ID`.

## Adding the runner

- From the Mac: `scripts/init-project/register-vps-runner.sh {project}`.
- From a cloud Claude thread (cannot SSH): paste-in prompt in
  `skills/init-project/reference.md`, "Runner setup from a cloud Claude thread".
