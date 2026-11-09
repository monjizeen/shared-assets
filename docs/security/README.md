# Security at Monjizeen

How we keep apps and workflows safe, and who does what.

## The weekly sweep
- **When**: every Monday. The free **Security scan** workflow (this repo) probes
  the live sites at 05:00 UTC; the Claude **security-check** skill
  (`skills/security-check`) then does the deeper repo check and fixes safe issues.
- **Safe fixes** go through a PR merged on green CI. **Risky ones** (auth,
  server config, production data, key rotation, major upgrades) are reported to
  Omar in plain language and wait for his go.
- Results are appended to `LOG.md` here.

## Baseline for every repo
1. Internal tools sit behind Monjizeen sign-in (`docs/deploy/STANDARD.md`).
2. Workflows: least-privilege `permissions:`, pinned actions, self-hosted
   runners only on `push` to main, never on fork PRs.
3. Dependabot on (composer, npm, github-actions), weekly.
4. Secret scanning and push protection on in GitHub settings (Omar, one click).
5. Secrets only in GitHub secrets / server `.env`; never in the repo or chat.
6. Production deploys and data migrations wait for Omar.

## Where Omar's action is needed (one-time)
- Turn on **Secret scanning + push protection** and **Dependabot alerts** for the
  org: GitHub → org Settings → Code security → "Enable all".
- Branch protection on `main` requiring CI (optional but recommended).
