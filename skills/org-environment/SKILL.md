---
name: org-environment
description: >
  Set up, run and cut off a client org's Environment: the account and env
  values (NAME = value) our AI agents use for that org, kept on its
  app.monjizeen.com org page, plus the guide its master agent follows and its
  monjizeen-agent repo. Use when onboarding a
  new org, adding or rotating its env values, writing its agent's instructions,
  splitting global, per-org and the org's own skills, or when someone says "new org",
  "set up environment", "connect Jira", "agent repo", "org agent setup".
---

# Org environment

Each client org keeps its own data. Our agents work with an account and keys
the org gives us and can switch off at any time. The org page in the
Monjizeen app has an **Environment** card (admins only): the org's values,
like a .env file (`NAME = value`), plus "Action needed" when one is expired or
refused.

Read with this skill: `AGENT-GUIDE.md` (what the org's agent gets) and
`STATUS-TEMPLATE.md` (the file the agent keeps). App side:
`monjizeen-app/docs/CLIENT_ENVIRONMENT.md`.

## Two hard rules

1. **No org learns about another.** Everything an org receives (its agent
   guide, its repo, its skills, Jira comments) names only that org. Never
   paste another client's name, ticket keys, repos or examples. Nothing
   given to an org may list our clients. That includes `shared-assets`
   itself (it has `clients/` and internal docs), so never give an org read
   access to this repo. Global skills go to orgs only from a repo or package
   that holds skills and nothing else (see "Skills").
2. **The org owns the account we use.** The org gives us an account on their
   side (like `monjizeen@company.com`, in their Google, Jira, GitHub and other
   tools). It gives us access to their tools, their agents and the skills they
   already have. When they stop working with us, they switch that one account
   off and all our access to their side is cut at once.
3. **Skills we write for an org stay ours.** They live in our GitHub, one
   folder per org (see "Skills"). When an org stops working with us, we keep
   the folder and tell them they will lose those skills.
4. **Their tool is the source of truth for ticket status.** Jira or whatever
   tool they use. We move a ticket in their tool first, then match it on our
   side. If their tool moves it, we follow.

## New org: what we do

Collect everything you'll need from the org in a single ask (step 1), not
one item at a time.

1. **Ask the org for, all at once:**
   - An account for Monjizeen on their side (like `monjizeen@company.com`), with
     access to their ticket tool (Jira or other), GitHub and agents. Only the
     access our work needs.
   - A private repo named `monjizeen-agent`, owned by that account (or in their
     GitHub org with that account as the only outside collaborator).
   - A Jira API token for that account (id.atlassian.com → Security → API
     tokens), with an expiry date.
   - A fine-grained GitHub key for that account: only the `monjizeen-agent`
     repo, Contents read-only (read and write only if our agents must push
     there), expiry ≤ 90 days. Classic `ghp_` keys are refused by the app.
   - Any other keys our agents need (Figma, GitLab, …), each with an expiry.
   - Written OK from whoever owns their data rules, if the org has any (for an
     employer of ours, always ask first).
2. **Add the values in the app:** org page → Environment → Add, one
   `NAME = value` per line of a .env file. Each value is locked straight away
   and never shown again (only its last 4 characters). The app uses these
   names itself:

   | Name | Value |
   |---|---|
   | `JIRA_URL` | `https://<name>.atlassian.net` |
   | `JIRA_EMAIL` | The Jira account's email |
   | `JIRA_TOKEN` | The Jira API token |
   | `AGENT_REPO` | `owner/monjizeen-agent` |
   | `GITHUB_TOKEN` | The fine-grained GitHub key |

   Any other name (`FIGMA_TOKEN`, `GITLAB_TOKEN`, …) is kept for our agents.
   Set access (read-only or read and write) and the expiry the org gave.
3. **Hand the agent its guide:** copy `AGENT-GUIDE.md`, fill in only this org's
   values, and add it to the org's master agent instructions (CLAUDE.md,
   project instructions, or Torus system prompt). Add `STATUS-TEMPLATE.md` to
   the repo as `STATUS.md`.
4. **Check it works:** press Refresh on the Environment card. Anything wrong
   shows under "Action needed". The agent's status shows in Context → Agent
   status, and the org's skills in the Org skills card.
5. **Never put values** in chat, notes, issues, STATUS files or this repo. The
   only place a client value lives is the app's Environment card.

## Running

- **Ticket status:** their tool decides. Move the ticket there first, then
  match ours. If their tool refuses the move, keep ours as it is, note it on
  our ticket, and ask on their ticket whether to keep working.
- **Values for our agents:** an agent gets only the values its task needs,
  at the moment it runs, and never prints, logs or repeats them (like any
  well-run AI tool). Values never go into prompts, commits, comments or chat.
- **Questions to the org:** ask on their ticket. We never write into their
  repo unless the org gave read-and-write access for that.
- **Rotation:** "Action needed" warns 14 days before a value expires. Ask the
  org for a new one, paste it into Edit (an empty value keeps the old one),
  and have them revoke the old one on their side.
- **History:** each value has its own History (added, changed, used by the
  app, removed). Check it if anything looks odd.

## Cutting off an org

1. Environment → Remove each value. That deletes them at once.
2. Ask the org to switch off the Monjizeen account on their side. That cuts
   every key and repo access in one step.
3. Delete any local copies of their files. Keep our folder of skills we
   wrote for them (we own it) and tell them they will lose those skills.

## Skills: global, ours per org, and theirs

- **Global skills and workflows** (ours, shared with every org) come from one
  source of truth. Orgs get them from a skills-only repo or a Claude Code plugin
  that holds **only** those skills: no client names, no `clients/` folder, no
  internal docs. Until that repo exists, send orgs a copy of the specific
  skill folders they need, never this whole repo.
- **Skills we write for one org** live in our GitHub, in
  `shared-assets/clients/<client>/skills/<name>/SKILL.md` (next to that
  client's STATUS.md). They are ours; the org's agent gets only that org's
  folder, never the whole repo.
- **The org's own skills** (ones they had before us) stay on their side. Our
  account reads them there. The org page's "Org skills" card lists what is in
  their agent repo.
- **Load order** for the org's agent: global first, then the ones we wrote for
  that org, then the org's own. A later one with the same name overrides an
  earlier one.
- Skills are plain markdown, so agents that can't install plugins (for
  example Torus) can read them as instructions.
