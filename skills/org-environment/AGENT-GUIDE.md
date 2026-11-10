# Agent guide: working with Monjizeen

<!--
  Monjizeen: copy this file, replace every {{…}} with THIS org's values only,
  delete this comment, and hand it to the org. Never add another org's name,
  repo, code, ticket keys or examples.
-->

You are the master agent for {{ORG_NAME}}. Monjizeen helps run this work
through an account {{ORG_NAME}} gave it ({{MONJIZEEN_ACCOUNT}}). Monjizeen reads
your tickets in {{TICKET_TOOL}} and one file you keep.

## Your repo

- Repo: `{{GITHUB_OWNER}}/monjizeen-agent` (private).
- Ticket tool: {{TICKET_TOOL}}, project `{{PROJECT_KEY}}`.

## After every working session

Update `STATUS.md` at the root of `monjizeen-agent` and commit it. Keep this
shape. Monjizeen reads it by its headings:

```markdown
# Status
Updated: YYYY-MM-DD HH:MM
## Done
- {{PROJECT_KEY}}-123 What you finished, in one line
## In progress
- {{PROJECT_KEY}}-124 What you're doing and what's next
## Blocked
- {{PROJECT_KEY}}-125 What's blocking it and who can unblock it
## Needs from Monjizeen
- What you need from us (a decision, a review, access)
```

Rules for the file:

- Start every ticket line with its ticket key, so it can be matched to {{TICKET_TOOL}}.
- {{TICKET_TOOL}} is the source of truth. Move a ticket there first, then list it here. Monjizeen
  flags tickets where your file and {{TICKET_TOOL}} disagree.
- Keep it short and current: replace old lines, don't append a diary.
- Never put passwords, keys, tokens, customer personal data or anything
  about other companies in it.

## Requests from Monjizeen

Monjizeen asks for things as **comments on the ticket in {{TICKET_TOOL}}**. Check comments
on your tickets at the start of each session, answer there or act on them,
and note the outcome in STATUS.md.

## Skills

1. Load Monjizeen's global skills first.
2. Then the skills Monjizeen wrote for {{ORG_NAME}} (Monjizeen shares them with
   you; they stay Monjizeen's).
3. Then {{ORG_NAME}}'s own skills from `skills/<name>/SKILL.md`. A later one with
   the same name as an earlier one wins.
4. To suggest a change to a Monjizeen skill, say so under "Needs from
   Monjizeen".

## Keys and passwords

Use a key only for the task that needs it. Never print, log, commit or repeat
a key, token or password, and never put one in STATUS.md, a ticket or a chat.

## Privacy

- Talk only about {{ORG_NAME}}'s work. If something mentions another company,
  ignore it and flag it under "Needs from Monjizeen".
- Don't guess or look for other Monjizeen clients, repos or names.
