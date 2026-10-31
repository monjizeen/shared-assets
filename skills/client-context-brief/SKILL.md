---
name: client-context-brief
description: >
  Build or update a client's kit (brand, audience, tone, rules, their own QA
  list, what they approved and rejected) and turn it into a one-page brief for a
  single task. Use at client onboarding, before any service skill starts work
  for a client, after a task is approved or rejected, or when someone says
  "client brief", "client kit", "onboard this client", "what do we know about
  this client", "prepare the brief for this ticket".
---

# Client context brief

Every Monjizeen service skill holds **our** method and standards. This skill
holds **the client's** side: who they are and what they want, written down once
so nobody asks them twice. Service skills read its output before they start.

Two outputs, kept separate:

| Output | Level | When | Lives in |
|---|---|---|---|
| **Client kit** | Organization (and project, if a project differs) | Once at onboarding, then updated after every task | monjizeen-app org / project docs |
| **Task brief** | Ticket | Before each task | The ticket description, or handed straight to the service skill |

Both use the item syntax monjizeen-core reads, so they plug into
`monjizeen brief --ticket <id>` with no extra work:

```markdown
- MUST [key]: A rule that can't be broken.
- SHOULD [key]: A preference. A more specific level can change it.
- CHECK [key]: Something QA must confirm before delivery.
```

Use a short `[key]` (like `[logo-space]`, `[tone]`, `[prices]`) whenever a
project or ticket might change the same rule later. Anything else in the doc is
a note.

## Golden rule

**Never invent client facts.** No guessed hex codes, made-up audiences,
imagined competitors or "probably formal" tone. If you don't know it, write
`Unknown, ask:` and the question. A short kit that is true beats a full kit that
is guessed. Mark anything you inferred (not told) with `(inferred from …)` so a
person can confirm it.

## Mode 1: Build the kit (onboarding)

1. **Collect what already exists, before asking anything.** In this order:
   - What the client sent: brand guide, logo files, past work, briefs.
   - Their website and social accounts (bio, last 12 posts, pinned posts).
   - Their app or store listing, if they have one.
   - Any notes already in monjizeen-app for this org or project.
2. **Fill [TEMPLATE.md](TEMPLATE.md)** from that material. Copy exact colour
   codes, font names and wording; don't paraphrase their own words.
3. **List the gaps.** Turn every `Unknown` into one plain question. Ask them in
   one message, most important first, at most 10. Offer choices when you can
   ("Formal or friendly?", "Arabic first, English first, or both?"). Use the
   question bank in [TEMPLATE.md](TEMPLATE.md#question-bank).
4. **Write the client's own QA list** as `CHECK` items. These are the things
   they always look for ("the logo is never on a busy photo", "phone number on
   every post"). If they gave none, leave the section with one line:
   `Unknown, ask: what do you always check before you approve?`
5. **Save it** as the org's "Client kit" doc in monjizeen-app (or as
   `client-kit.md` if the app isn't in use). A project that differs from the org
   (a sub-brand, a different audience) gets its own short doc with only the
   differences.

## Mode 2: Write a task brief

Before a service skill starts on a ticket:

1. Read the client kit (org, then project). If the Monjizeen CLI is set up, run
   `monjizeen brief --ticket <id>`; it already merges every level.
2. Read the ticket: title, description, checklist, comments, attachments.
3. Fill the **Task brief** part of [TEMPLATE.md](TEMPLATE.md#task-brief). One
   page. Only what this task needs; link to the kit for the rest.
4. Name the deliverable exactly: format, sizes, languages, count, deadline.
5. Copy over only the kit rules that apply to this task, and add task rules
   from the ticket.
6. If the ticket clashes with the kit (e.g. the ticket asks for a colour the
   kit forbids), don't pick a side. Put it under **Open questions** and ask.
7. Hand the brief to the service skill (e.g. `social-media-graphic`).

## Mode 3: Learn from the result

After the client approves or rejects a task:

1. Add one line to the kit's **Approved and rejected** log: date, task, result,
   and why in the client's words.
2. If the reason is a lasting preference, add it as a `SHOULD` (or `MUST` if
   they said "never" or "always") with a key, and note the date.
3. If the same rejection reason shows up twice, add it as a `CHECK`.
4. Keep the kit short. Merge duplicates. Remove rules the client reversed (and
   log that they did).

## Quality checks

- CHECK [kit-sources]: Every fact in the kit came from the client or their own
  material, or is marked `(inferred from …)`.
- CHECK [kit-unknowns]: Every gap is written as `Unknown, ask:` with a question,
  not filled with a guess.
- CHECK [kit-exact]: Colours, fonts, names, phone numbers and legal lines are
  copied exactly, in both languages if the client uses both.
- CHECK [brief-deliverable]: The task brief names format, sizes, languages,
  count and deadline.
- CHECK [brief-conflicts]: Any clash between the ticket and the kit is listed as
  an open question, not resolved silently.
- CHECK [brief-short]: The task brief fits on one page.

## What this skill does not do

- It does not decide strategy for the client (positioning, pricing, which
  campaign to run). If a task needs that, the client's own person gives a brief,
  or the task isn't ours.
- It does not store Monjizeen's methods. Those live in each service skill.
