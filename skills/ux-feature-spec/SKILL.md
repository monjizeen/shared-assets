---
name: ux-feature-spec
description: >
  Turn a feature request or a "Research" design task into a UX spec a
  designer and developer can build from: the user's job, the flow, every
  state and edge case, the rules for when each block shows, the texts and a
  definition of done. Use for "research task", "UX spec", "user flow",
  "define the states", "edge cases", "مسار المستخدم", "دراسة الميزة",
  "proposal", or before screens are designed for a new feature.
---

# UX feature spec

Our method for the thinking before pixels: what the user needs, what the
system can and cannot give, and every case the screens must handle. A good
spec makes the design task obvious and leaves no "what happens if…" for the
developer.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.
Template parts come from monjizeen-core `notes/ux/templates/flow.md` and
`recommendations.md`.

## Before you start

1. Read the request, the product context and every linked ticket, mock-up
   and API note. **Write down what the data source gives and does not give**
   (fields, when they are missing, limits). Most edge cases come from there.
2. Find the **existing pattern** the feature should follow in the product
   (a similar drawer, list, block). Reuse beats invent; name it.
3. If a rule depends on a fact the brief does not have (a regulation, an API
   field), list it as an open question; do not decide it yourself.

## How to do it

1. **Problem and job.** Who, in what situation, needs what, and what happens
   today without it. One JTBD line.
2. **Scope.** In / out, platforms (iOS, Android, web, breakpoints), roles
   (owner, read-only, admin), languages.
3. **Entry points.** Every way the user reaches it (list row, deep link,
   notification, search), and what the page shows when opened directly.
4. **Flow.** The happy path as numbered steps (screen → action → system
   response), then a Mermaid `flowchart TD` with decisions and error
   branches. Every branch has a way back.
5. **Content model.** Each block and row: its label, the data behind it, the
   format (dates, amounts, masked numbers), and **the rule for when it
   shows** ("only when the backend sends `consent_date`; otherwise the row is
   hidden, not empty").
6. **States matrix.** Rows = the cases that change the screen (data present,
   partial, missing; roles; statuses; limits reached; long values); columns
   = what each block shows. Use UX-STANDARDS §4 as the minimum.
7. **Rules.** Numbered, testable, one sentence each ("R3: A limit with
   nothing left shows 'Used up', even when used is above the limit").
8. **Texts.** Every visible string (titles, labels, empty and error texts,
   buttons) in each language the product ships, or marked "copy needed"
   with a `ux-writing` hand-off.
9. **Design and build notes.** Components to reuse (by library name), what
   is new, accessibility notes, analytics events if the brief asks.
10. **Definition of done.** A checklist the designer ticks: every state
    drawn, every platform, every role, texts final.
11. **Open questions**, each with who should answer.

## Output

```
# <Feature>: UX spec
## Problem and job
## Scope (in / out, platforms, roles, languages)
## Entry points
## Flow (steps + Mermaid diagram)
## Content model (| Block / row | Data | Format | Shows when |)
## States matrix
## Rules (R1, R2, …)
## Texts (| Key | English | Arabic / other |)
## Design and build notes
## Definition of done (checklist)
## Assumptions and open questions (who answers)
```

## Standards for MENA work

- Define how amounts, dates (Gregorian or Hijri), digits and masked numbers
  look in each language, and that they keep left-to-right order in RTL.
- Gendered and formal Arabic wording follows UX-STANDARDS §5.
- Where a regulator or a religious board sets the wording, quote the source
  and keep it word for word.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [spec-data]: The spec says what the data source gives and does not
  give, and every block has a "shows when" rule that covers missing data.
- CHECK [spec-states]: The states matrix covers every role, status and
  data case named in the brief, plus empty, error and long content.
- CHECK [spec-flow]: The flow has a diagram, every decision has both
  branches, and every branch has a way back or out.
- CHECK [spec-rules]: Rules are numbered and each one can be tested with a
  yes or no.
- CHECK [spec-reuse]: The spec names the existing product pattern or
  component it follows, or says why a new one is needed.
- CHECK [spec-dod]: The definition of done lists every platform, role and
  state to be drawn.
- CHECK [spec-texts]: Every visible string is written or marked "copy
  needed".
