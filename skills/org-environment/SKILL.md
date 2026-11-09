---
name: org-environment
description: >
  Set up, run and cut off a client org's Environment: the read-only link from
  Monjizeen (app.monjizeen.com org page) into that org's own Jira and private
  status repo, plus the guide its master agent follows. Use when onboarding a
  new org, connecting or rotating its keys, writing its agent's instructions,
  splitting global vs company-only skills, or when someone says "new org",
  "set up environment", "connect Jira", "status repo", "org agent setup".
---

# Org environment

Each client org keeps its own data. Monjizeen only **reads** it, with keys the
org gives us and can revoke at any time. The org page in the Monjizeen app has
an **Environment** card (admins only) that shows real Jira status next to what
the org's master agent reported, joined by ticket key.

Read with this skill: `AGENT-GUIDE.md` (what the org's agent gets) and
`STATUS-TEMPLATE.md` (the file the agent keeps). App side:
`monjizeen-app/docs/CLIENT_ENVIRONMENT.md`.

## Two hard rules

1. **No org learns about another.** Everything an org receives (its agent
   guide, its repo, its skills, Jira comments) names only that org. Never
   paste another client's name, ticket keys, repo, code or examples. Nothing
   given to an org may list our clients. That includes `shared-assets`
   itself (it has `clients/` and internal docs), so never give an org read
   access to this repo. Global skills go to orgs only from a repo or package
   that holds skills and nothing else (see "Skills").
2. **Nothing is guessable.** Each org gets a random code in the app
   (Environment card, 12 lowercase letters/digits). Its status repo is
   `env-<code>`, never the client's name and never a pattern like
   `client1-status`. Use the same code for anything else we name for that
   org. Don't reuse a code, and don't derive one from the org name.

## New org: what we do

Work through these in order. Collect everything you'll need from the org in a
single ask (step 1), not one item at a time.

1. **Ask the org for, all at once:**
   - Their Jira Cloud address (`https://<name>.atlassian.net`).
   - A **read-only Jira account** (a service account is best): its email and
     an API token (id.atlassian.com → Security → API tokens), with an expiry
     date if they can set one.
   - A **private repo in their own GitHub org**, named `env-<code>` (take the
     code from the org's Environment card in the app).
   - A **fine-grained GitHub key** for that one repo: Repository access =
     only that repo, Permissions = Contents: Read-only, nothing else,
     expiry ≤ 90 days. Classic `ghp_` keys are refused by the app.
   - Written OK from whoever owns their data rules, if the org has any
     (for an employer of ours, always ask first).
2. **Connect in the app:** org page → Environment → Connect (Jira), then
   Connect (Status repo). Paste each key once; it is locked straight away and
   never shown again (only its last 4 characters). Keep the expiry the org set,
   or 90 days.
3. **Hand the agent its guide:** copy `AGENT-GUIDE.md`, fill in only this org's
   values (repo, Jira project, code), and give it to the org to put in their
   master agent's instructions (CLAUDE.md, project instructions, or Torus
   system prompt). Add `STATUS-TEMPLATE.md` to the repo as `STATUS.md`.
4. **Check it works:** press Refresh on the Environment card. Expect tickets,
   the agent's report and company skills. Errors show on the card and in the
   use log.
5. **Never put keys** in chat, notes, issues, STATUS files or this repo. The
   only place a client key lives is the app's Environment card.

## Running

- **Asking the org for something:** use **Ask** on the ticket in the
  Environment card. It posts a Jira comment, so their team sees it too. We
  never write into their repo.
- **Rotation:** the card warns 14 days before a key expires. Ask the org for
  a new key, paste it into Edit (leaving the key field empty keeps the old
  one), and have them delete the old key on their side.
- **Use log:** every connect, key change, read, request and disconnect is
  logged on the card. Check it if anything looks odd.

## Cutting off an org

1. Environment → Disconnect, for both Jira and the status repo. That deletes
   the saved keys at once.
2. Ask the org to revoke both keys on their side and to remove our access to
   the repo.
3. Remove any company-only skills of theirs from our machines. We keep no
   copies.

## Skills: global and company-only

- **Global skills and workflows** (ours, shared with every org) come from one
  source of truth. Orgs get them from a skills-only repo or a Claude Code plugin
  that holds **only** those skills: no client names, no `clients/` folder, no
  internal docs. Until that repo exists, send orgs a copy of the specific
  skill folders they need, never this whole repo.
- **Company-only skills** live in the org's own status repo under
  `skills/<name>/SKILL.md`. They never leave it. The Environment card lists their
  names, so we know what the org's agent uses.
- **Load order** for the org's agent: global first, then company-only. A
  company skill with the same name overrides the global one.
- Skills are plain markdown, so agents that can't install plugins (for
  example Torus) can read them as instructions.
