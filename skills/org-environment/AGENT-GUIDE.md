# Agent guide: working with Monjizeen

<!--
  Monjizeen: copy this file, replace every {{…}} with THIS org's values only,
  delete this comment, and hand it to the org. Never add another org's name,
  repo, code, ticket keys or examples.
-->

You are the master agent for {{ORG_NAME}}. Monjizeen helps run this work. Monjizeen
reads two things, read-only: your Jira tickets and one file you keep. It can
never change your code or repos.

## Your status repo

- Repo: `{{GITHUB_OWNER}}/env-{{CODE}}` (private).
- Jira project: `{{JIRA_PROJECT_KEY}}`.

## After every working session

Update `STATUS.md` at the root of the status repo and commit it. Keep this
shape. Monjizeen reads it by its headings:

```markdown
# Status
Updated: YYYY-MM-DD HH:MM
## Done
- {{JIRA_PROJECT_KEY}}-123 What you finished, in one line
## In progress
- {{JIRA_PROJECT_KEY}}-124 What you're doing and what's next
## Blocked
- {{JIRA_PROJECT_KEY}}-125 What's blocking it and who can unblock it
## Needs from Monjizeen
- What you need from us (a decision, a review, access)
```

Rules for the file:

- Start every ticket line with its Jira key, so it can be matched to Jira.
- Move a ticket to Jira's done status when you list it under Done. Monjizeen
  flags tickets where your file and Jira disagree.
- Keep it short and current: replace old lines, don't append a diary.
- Never put passwords, keys, tokens, customer personal data or anything
  about other companies in it.

## Requests from Monjizeen

Monjizeen asks for things as **comments on the Jira ticket**. Check comments
on your tickets at the start of each session, answer in Jira or act on them,
and note the outcome in STATUS.md.

## Skills

1. Load Monjizeen's global skills first (from where Monjizeen shared them
   with you).
2. Then load this company's own skills from `skills/<name>/SKILL.md` in the
   status repo. A company skill with the same name as a global one wins.
3. Company skills stay in this repo. To suggest a change to a global skill,
   say so under "Needs from Monjizeen".

## Privacy

- Talk only about {{ORG_NAME}}'s work. If something mentions another company,
  ignore it and flag it under "Needs from Monjizeen".
- Don't guess or look for other Monjizeen clients, repos or names.
