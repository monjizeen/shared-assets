# Operations: running several orgs from one place

How Monjizeen runs its clients (about five today), with AI agents and without.
Everything starts in the Monjizeen app (app.monjizeen.com): **one organization
per client, projects inside it, tickets inside projects.** If it is not in the
app, it did not happen.

This page is the procedure. The detailed setup of one org is in
[`skills/org-environment`](../../skills/org-environment/SKILL.md); working a
client agent's requests is [`skills/agent-requests`](../../skills/agent-requests/SKILL.md);
keeping project descriptions in line is
[`skills/align-project-docs`](../../skills/align-project-docs/SKILL.md).
When a step changes, change it here first.

## 1. What lives where

| Thing | Lives in |
|---|---|
| Client, its projects, tickets, time | Monjizeen app (org → project → ticket) |
| What a project is, brief, decisions, notes | The project's context docs in the app |
| Client's keys and accounts | The org's **Environment** card (never chat, never git) |
| Client's own agent connection | Environment → Their agent (Monjizeen MCP key) |
| Services a client may ask for | Admin → Packages, for the org's package |
| Skills, roles, workflows | `shared-assets` (`skills/`, `roles/`, `workflows/`) |
| Rules and quality checks for AI work | `monjizeen-core` |
| Our own products (Radar, Elham, Sandooq, Asaas, Kawader…) | Organization **Monjizeen**, one project each; shared skills and context in "Shared assets" |

No client ever sees another client. Nothing given to a client names another one.

## 2. Onboard a new client (with or without AI)

1. **Create the organization** (Organizations → New). Name = the client's name.
   The app adds its first project automatically.
2. **Pick the package.** Admin → Packages → tick the services this client buys.
   Only services marked ready are offered to their agent.
3. **Create the projects.** One per product or workstream. Give each a brief
   (first line = one-sentence description; see `align-project-docs`).
4. **Write the org brief and context.** Organization Brief, brand context, rules
   and standards in the org's context docs. This is what our work reads.
5. **Ask the client once, for everything** (see `org-environment`): an account
   for us on their side, a key per tool with an expiry, whether they have their
   own AI agent, their data rules.
6. **Add the keys** on the org's Environment card. Check **Action needed** is empty.
7. **Their agent, if any:** Environment → Their agent → **Connect agent**, send
   them the setup prompt and the key privately. Test it: their agent calls
   `list_services` and `get_org_context`.
8. **Note it.** Add the client to the list in section 5.

Without an AI agent steps 1 to 6 are the same. Skip step 7: the client asks us
by message, and we create the ticket for them.

## 3. Daily operation

**With their agent:** it sends `request_work`; the request appears as a ticket in
that org (status Backlog). Our agent works it with the `agent-requests` skill,
checks it with `qa-reviewer`, and delivers. Their agent approves or asks for
changes; changes go back to the queue. Feedback is sorted by `feedback-auditor`.

**Without AI (today's default for most clients):**
1. The client asks (message, call, email). Create a ticket in the right project.
2. Assign it. The doer works and logs time as work updates.
3. Omar reviews before anything leaves Monjizeen.
4. Deliver, then mark the ticket done after the client confirms.

Same rules either way: one task at a time per client, finished work only, Omar
approves every delivery, no work for a client outside a ticket.

## 4. Review (for now)

Omar reviews every agent delivery. Until a dedicated review tool exists, each
delivery is a ticket in Ready for review under its org and project. Open the
list of tickets in that status, filter by org or project, review, then approve
or send back. Record why in the ticket's comments, because comments feed the
`feedback-auditor`.

## 5. Weekly check (10 minutes, every client)

- Environment: nothing under **Action needed**; keys expiring within 14 days renewed.
- Tickets: nothing stuck in Ready for review for more than two days.
- Hours: monthly limit not about to be passed (org page).
- Agent clients: its requests are moving; if their agent has gone quiet, ask.
- Clients list (keep this table current):

| Client | Package | Own agent | Last checked |
|---|---|---|---|
| _name_ | _package_ | yes/no | _date_ |

## 6. Cutting off a client

Follow "Cutting off an org" in `skills/org-environment`: remove their values,
ask them to switch off our account on their side, disconnect their agent, delete
local copies, keep the skills we wrote for them.

## 7. Access: one agent per org

- **Our team's admin key** reaches every org. It stays with our own agents.
- **A client's agent** gets a key from Connect agent that reaches **only its
  org**. One key per org, never shared.
- Trying a new org's agent: connect it, run `list_services` and `get_org_context`
  as that agent, and send a small `request_work`. Check it cannot see any other
  org (a call with another org's id must fail).
- Never put a key in chat, a ticket, a commit or this repo. Keys live in the
  place that uses them (the Environment card, an agent's own secrets).

## 8. Governance: write it down once

- Anything done twice becomes a step on this page or a skill, with a name.
- A decision goes into the project's `decisions` doc with the date.
- A change to a procedure is a change to this file, reviewed like code.
- If an agent invents a way of working, it records it here or as a skill
  before the next client uses it.
