---
name: org-environment
description: >
  Set up, run and cut off a client org's Environment: the account and env
  values (NAME = value) our AI agents use for that org, kept on its
  app.monjizeen.com org page, and connecting the org's own agent to our MCP
  (setup prompts for us and for their agent). Use when onboarding a
  new org, adding or rotating its env values, writing its agent's instructions,
  splitting global, per-org and the org's own skills, or when someone says "new org",
  "set up environment", "connect Jira", "connect their agent", "org agent setup".
---

# Org environment

Each client org keeps its own data. Our agents work with an account and keys
the org gives us and can switch off at any time. The org page in the
Monjizeen app has an **Environment** card (admins only): the org's values,
like a .env file (`NAME = value`), plus "Action needed" when one is expired or
refused.

Read with this skill: `OUR-SETUP-PROMPT.md` (the prompt we use to set up
an org) and `ORG-AGENT-PROMPT.md` (what the org's own agent gets). App side:
`monjizeen-app/docs/CLIENT_ENVIRONMENT.md`.

The app is the live status of every org's work. There is no STATUS.md for
the org's agent any more: their agent works through our MCP instead.

## Hard rules

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
   side. If their tool moves it, we follow. This is only for tickets we work
   in their tool; their own agent never syncs tickets with us.
5. **Monjizeen executes.** Their agent asks us for work; our agent does it
   with our tools and skills and delivers; they review. We never ask for
   dailies, work logs or status updates. Human review is a separate hire
   through Kawader, not part of Monjizeen.

## New org: what we do

Follow `OUR-SETUP-PROMPT.md`. In short:

1. **Ask the org once, for everything:** an account for us on their side
   (like `monjizeen@company.com`), a key for each tool our work needs (made
   from that account, each with an expiry), whether they have their own AI
   agent, and their data rules.
2. **Add the keys** on the org page → Environment → Add, one `NAME = value`
   each, like a .env file. A value is locked straight away and never shown
   again. The app uses these names itself:

   | Name | Value |
   |---|---|
   | `JIRA_URL` | `https://<name>.atlassian.net` |
   | `JIRA_EMAIL` | The Jira account's email |
   | `JIRA_TOKEN` | The Jira API token |
   | `AGENT_REPO` | `owner/repo` of their agent's repo (optional: lists its skills) |
   | `GITHUB_TOKEN` | A fine-grained, read-only GitHub key for that repo |

   Any other name (`FIGMA_TOKEN`, `GITLAB_TOKEN`, …) is kept for our agents.
   Don't type access: the app tests each key (Jira: may it move tickets and
   comment?) and reads GitHub keys' expiry. Type an expiry only when the
   service shows one the app can't read. Some, all or none of the tools is
   fine: with none, we just work in Monjizeen with our own agents.
3. **Their own agent (if they have one):** Environment → Their agent →
   **Connect agent**. It gets a Monjizeen key that only reaches this org
   (shown once: send it privately) and connects through our MCP. Send it
   `ORG-AGENT-PROMPT.md` (**Copy setup prompt** fills it in). It asks us for
   work in the services of the org's package (Admin → Packages picks them),
   keeps the org's context current, and approves our deliveries or asks for
   changes. We work its requests with the `agent-requests` skill.
4. **Check it works:** Refresh on the card. Anything wrong shows under
   "Action needed".
5. **Never put values** in chat, notes, issues or this repo. The only place a
   client value lives is the app's Environment card.

## Running

- **Requests from their agent:** `agent-requests` (do the work, `qa-reviewer`
  before delivery, `feedback-auditor` on their feedback).

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
3. Environment → Their agent → Disconnect (its Monjizeen key stops at once).
4. Delete any local copies of their files. Keep our folder of skills we
   wrote for them (we own it) and tell them they will lose those skills.

## Skills: global, ours per org, and theirs

- **Global skills and workflows** (ours, shared with every org) come from one
  source of truth. Orgs get them from a skills-only repo or a Claude Code plugin
  that holds **only** those skills: no client names, no `clients/` folder, no
  internal docs. Until that repo exists, send orgs a copy of the specific
  skill folders they need, never this whole repo.
- **Skills we write for one org** live in our GitHub, in
  `shared-assets/clients/<client>/skills/<name>/SKILL.md` (next to that
  client's internal STATUS.md). They are ours; the org's agent gets only
  that org's folder, never the whole repo.
- **The org's own skills** (ones they had before us) stay on their side. Our
  account reads them there. The org page's "Org skills" card lists what is in
  their agent repo.
- **Load order** for the org's agent: global first, then the ones we wrote for
  that org, then the org's own. A later one with the same name overrides an
  earlier one.
- Skills are plain markdown, so agents that can't install plugins (for
  example Torus) can read them as instructions.
