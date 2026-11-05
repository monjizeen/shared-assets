# How Monjizeen projects deploy

One standard, so every repo looks the same. New projects get it from
`/new-project` (Gate 8); the workflow text lives in
`skills/init-project/reference.md`. Internal tools also get Monjizeen
sign-in (Gate 5, see "Internal tools" below).

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

## Internal tools: Monjizeen sign-in, always (Omar, 2026-11-05)

Every internal tool (Radar, Elham, Sandooq, Kawader and any new one) sits
behind the **same allowed users as app.monjizeen.com**. Build it that way from
the first commit; never ship one open "for now".

1. **No own login.** No Google client per tool, no `ALLOWED_EMAILS`, no basic
   auth. The tool uses *Sign in with Monjizeen*: it sends people to
   `https://app.monjizeen.com/tools/{tool}/sign-in?state=…`, gets a one-time
   code back on its callback, and swaps it server to server at
   `POST https://app.monjizeen.com/api/tools/{tool}/redeem`. Who may enter is
   decided only in the app (team and doers, never client-only members).
   Full guide: monjizeen-app `docs/TOOL_SIGN_IN.md`.
2. **Register the tool** with one line in monjizeen-app `config/tools.php`
   (slug, name, callback URL), merge, and deploy the app to production.
3. **Gate everything**, not just the API: pages, JSON, images, videos,
   downloads. Node/static tools: nginx `auth_request` to the tool's
   `/api/auth/check` (copy radar `docs/SIGN-IN.md` and the sign-in part of
   `server/server.mjs`). Laravel tools: the same three steps as a controller +
   `auth` middleware on every route.
4. **Never let Cloudflare cache gated files**: media headers say
   `Cache-Control: private`.
5. **Check after deploy**: `curl -s -o /dev/null -w "%{http_code}" https://{tool}.mnjz.in/`
   must give `302` (to sign in), never `200`.
6. Short tool sessions (about 7 days), so removing someone in the app locks
   them out of every tool within a week.

## Adding the runner

- From the Mac: `scripts/init-project/register-vps-runner.sh {project}`.
- From a cloud Claude thread (cannot SSH): paste-in prompt in
  `skills/init-project/reference.md`, "Runner setup from a cloud Claude thread".
