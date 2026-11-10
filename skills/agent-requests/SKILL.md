---
name: agent-requests
description: >
  Work the queue of requests that client orgs' own agents send to Monjizeen
  through our MCP: pick a request, load the service skill, the client's
  custom skills and the org's context, do the work with our tools (Radar,
  Sandooq), run the QA reviewer, then deliver. Also covers internal "test
  flights" of a service skill. Use when someone says "work the requests",
  "open requests", "deliver request", "test flight", "run the queue".
---

# Agent requests

Monjizeen executes: a team of AI achievers, by field (designer, marketer,
analyst…; the service's `role`). An org's own agent asks us for work in a
service its package includes; our achiever does it, QA checks it, we
deliver; the client approves it or asks for changes. We are not their ticket system, and we never ask them for
dailies, work logs or status updates.

App side: `monjizeen-app/docs/CLIENT_ENVIRONMENT.md` ("Their own agent").

## Connect

Our sessions use the same MCP as their agents, with an **admin** Monjizeen
key (the session's own secret, never printed):
`POST https://app.monjizeen.com/mcp`, `Authorization: Bearer mjz_…`.
An admin key also gets `list_open_requests` and `deliver`, and passes
`organization_id` to `list_services` and `get_org_context`.

## Work one request

1. **Pick.** `list_open_requests` (waiting for us, oldest first). A request
   with feedback `changes_needed` comes back to the queue: do it first.
2. **Read everything before starting.** `get_request` (brief, input links,
   earlier deliveries and the client's feedback), then
   `get_org_context organization_id=<id>`.
3. **Load skills in this order** (a later one overrides an earlier one):
   1. the service skill: `skills/<service>/SKILL.md` (the request's `service`);
   2. the client's custom skills: `clients/<client>/skills/` (ours, built from
      their past feedback);
   3. the org's own skills, if their Environment card lists them.
4. **Do the work** with our tools. Radar gives answers, never bulk data:
   ask it the questions the brief needs and cite what you used. Sandooq (the
   inspiration board and toolbox) when it exists.
5. **QA before delivery.** Run the `qa-reviewer` skill on the result. Fix
   every FAIL. Deliver only when the reviewer passes it, or when what is left
   needs the client's answer (say so in the note).
6. **Deliver.** Put each file behind a private, shareable https link (never a
   public repo or public link), then
   `deliver request_id=<id> note="…" links=[…]`. The note says what you made,
   what you assumed, and anything the client must decide. Keep it short.
7. **When feedback arrives,** run the `feedback-auditor` skill on it. Do not
   change a skill until we have reviewed its sorting.

If a brief is too thin to start, don't guess and don't deliver. Ask one short
question as a comment on the request's ticket in the app; their agent sees it
in `get_request`. When answered, add it to the org's context so it is never
asked again.

## Test flights (internal)

Before a service skill is marked ready (`config/agent_services.php` in
monjizeen-app), fly it on our own work:

1. Make a test request in an internal org (one of ours, never a client's),
   with a realistic brief.
2. Work it exactly as above, including the QA reviewer.
3. We review the delivery and give feedback with `send_feedback` like a
   client would. Run the `feedback-auditor` on it.
4. Repeat until the reviewer and we agree on three deliveries in a row. Then
   mark the service ready in SERVICES.md and the app config.

## Rules

- No org learns another exists. A delivery, note or link names only that org.
- Client keys are used only at run time, only the ones the task needs, and
  are never printed, logged or put in a note, link or skill.
- Client rules go in `clients/<client>/skills/`, never in a global skill.
- Human review never happens inside Monjizeen. Every delivery carries an
  optional "Want an expert check?" link (`expert_check`) to matching Kawader
  experts with hourly rates. The client hires directly or through us, and the
  review happens in the client's own tools. Never copy client work into
  Monjizeen or Kawader for it.
