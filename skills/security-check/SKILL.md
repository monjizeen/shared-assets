---
name: security-check
description: Weekly security sweep of every Monjizeen repo and live site. Finds dependency holes, leaked secrets, risky workflow permissions, open internal tools and header gaps; fixes safe ones by PR, reports risky ones to Omar. Use when asked for a security check, audit or sweep.
---

# security-check

Runs weekly (see `docs/security/README.md`) or on request. Keep it cheap:
reuse the automated scan first, only read code where it points.

## 1. Reuse what exists
- Read the latest run of `shared-assets` workflow **Security scan** (live-site
  probe) and each repo's Dependabot PRs/alerts. Do not redo what they report.
- Repo list: `docs/REPOS.md`. Internal-tool rule: `docs/deploy/STANDARD.md`
  "Internal tools" (everything but the public site sits behind Monjizeen sign-in).

> For a one-off deep dive on one app (before a launch or handover) use `pre-mvp-audit` instead; it needs a core loop, so it is too heavy for the weekly sweep. This skill reuses only its security lens.

## 2. Checks per repo
1. **Dependencies**: `composer audit`, `npm audit --omit=dev`, `pip-audit` where
   the lockfile exists. Patch/minor bumps with green tests = safe.
2. **Secrets**: scan the tree and recent history (gitleaks, or
   `run_secret_scanning`). Any real secret = report at once, never paste it.
3. **Workflows**: top-level `permissions:` set to least privilege; third-party
   actions pinned to a version (SHA for non-GitHub/non-org actions); no
   `pull_request_target` checking out PR code; no secrets echoed; self-hosted
   runners only on trusted events (never on PRs from forks).
4. **Exposure**: internal tools (radar, kawader, staging, Elham/Sandooq when
   built) must answer 401/302 to sign-in without a session; no `.env`, `.git`,
   `storage/logs`, debug pages, or directory listings reachable.
5. **Code smells** (grep, no deep audit): `APP_DEBUG=true` committed, raw SQL
   with string interpolation, `dangerouslySetInnerHTML`/`v-html` on user data,
   CORS `*` with credentials, missing auth middleware on new routes, uploads
   without type/size checks.
6. **Extension**: permissions in `manifest.json` not wider than needed; API
   host limited to production/staging.

## 3. Act
- **Safe, fix it**: dependency patch/minor bumps, pinning actions, adding
  `permissions:`, adding security headers, removing committed debug flags.
  One small PR per repo, mark it `security`, merge when CI is green and there
  are no conflicts (standing rule).
- **Ask Omar first**: anything touching production data, auth behavior,
  nginx/server config, key rotation, major version upgrades, or anything that
  could lock users out. Never rotate or delete a secret yourself.
- **Never**: print a secret value, disable a test to get green, push empty
  commits.

## 4. Report (plain language, no jargon)
One message: what is fine, what you fixed (PR links), what needs Omar (one line
each, with the exact action). If nothing is wrong, say "All clear" and stop.
Append the date and result to `docs/security/LOG.md`.
