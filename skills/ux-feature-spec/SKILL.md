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

0. Check the ticket's definition of done. When it asks for designs, this
   spec is step one: say so in the status line, and the delivery is not
   done until ui-screen-design draws the screens from it.
1. Read the request, the product context and every linked ticket, mock-up
   and API note. Open the frames of the screens being extended and map each
   term in the ticket to the exact frame (UX-STANDARDS §1.4). If the
   starting input (a designer's proposal, a prototype) cannot be opened,
   say so in the status line and keep anything that depends on it as a
   proposal. **Write down what the data source gives and does not give**
   (fields, when they are missing, limits). Most edge cases come from there.
2. Find the **existing pattern** the feature should follow in the product
   (a similar drawer, list, block). Reuse beats invent; name it. Read
   component and instance names from Figma `get_metadata` (layer names);
   read visible text from screenshots or `get_design_context`. When a
   frame's layer name and what it shows differ, cite the node id and what
   it shows.
3. **Look in the file before you ask.** Open every case frame in the linked
   section; a question the file already answers is a failure. Today's
   behaviour you have no frame for is written "not seen", never guessed
   (no "Retry button as today" without a frame).
4. If a rule depends on a fact the brief does not have (a regulation, an API
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
   branches. Every branch has a way back, and returns where the user came
   from. A state you have not seen gets no invented action in the diagram
   either (label it "not seen, Q<n>").
5. **Content model.** Each block and row: its label, the data behind it, the
   format (dates, amounts, masked numbers), and **the rule for when it
   shows** ("only when the backend sends `consent_date`; otherwise the row is
   hidden, not empty").
6. **States matrix.** Rows = the cases that change the screen (data present,
   partial, missing; roles; statuses; limits reached; long values); columns
   = what each block shows. Use UX-STANDARDS §4 as the minimum.
7. **Rules.** Numbered, testable, one sentence each, each with its source
   and its status: *settled* (quoted from the ticket or a doc) or
   *proposal* (your decision, with why). Example shape only: "R3: When the
   backend sends no end date, the End date row is hidden. Source: ticket §2,
   settled."
8. **Texts.** Every visible string (titles, labels, empty and error texts,
   buttons). Columns are the languages the product ships (from the brief),
   not a fixed English/Arabic pair. Each string is *existing* (today's
   string, reused), *proposed* (your draft, to be confirmed) or *copy needed*
   (hand off to `ux-writing`). Never present a proposed string as the
   client's. List new strings and changed ones; unchanged strings of the
   extended screens are not listed. Strings of parts not designed yet
   (a chart's labels) are rows marked "copy needed, depends on <input>".
9. **Design and build notes.** Components to reuse (by library name), what
   is new, accessibility notes, analytics events if the brief asks.
10. **Definition of done.** A checklist the designer ticks: every state
    drawn, every platform, every role, texts final.
11. **Open questions**, each with who should answer, blocking ones first
    ("Blocks drawing: …").
12. **Consistency pass.** Read the flow, the states matrix, the rules and
    the assumptions side by side. Any step that contradicts a rule, an
    assumption that restates a settled rule, or a case in the brief with no
    row, is fixed before handing over. Contradictions between the client's
    own frames (one value on the list, another on the detail) become
    non-blocking questions.

## Output

Start with a **Ticket terms → frames** table (| Ticket term | Frame / node |
Sure? |), where Sure? is *yes* (the frame shows exactly this), *partly* (say
what is missing) or *no*. A term you could not map gets an assumption and a blocking
question.

Follow this block, not the headings of the Core templates it borrows from.

```
Status: … / Inputs used: … / Not opened: …
# <Feature>: UX spec
## Problem and job
## Ticket terms → frames
## Scope (in / out, platforms, roles, languages)
## Entry points
## Flow (steps + Mermaid diagram)
## Content model (| Block / row | Data | Format | Shows when |)
## States matrix
## Rules (| # | Rule | Source | Settled or proposal |)
## Texts (| Key | <each shipped language> | Existing / proposed / copy needed |)
## Design and build notes
## Definition of done (checklist)
## Assumptions and open questions (who answers; blocking first)
```

## Standards for MENA work

(When the product has no Arabic, write one line "Arabic/RTL: N/A" and
instead define, per shipped language, the decimal and thousands separators,
where the currency symbol goes, and the longest-language case.)

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
- CHECK [spec-flow]: The flow has a diagram with at least one error branch,
  every decision has both branches, and every end point in the diagram has
  a way back or out drawn.
- CHECK [spec-sources]: Every rule has a source and is marked settled or
  proposal; no proposal is worded as the client's decision.
- CHECK [spec-consistent]: The flow, states matrix, rules and assumptions do
  not contradict each other.
- CHECK [spec-not-seen]: Nothing marked "not seen" is described, drawn or
  given an action anywhere (text, tables, diagram). A screen still to be
  drawn with no current frame reads "not seen; draw after Q<n>", and any
  expectation about it lives only in that question.
- CHECK [spec-rules]: Rules are numbered and each one can be tested with a
  yes or no.
- CHECK [spec-reuse]: The spec names the existing product pattern or
  component it follows, or says why a new one is needed.
- CHECK [spec-dod]: The definition of done lists every platform and role,
  and every states-matrix row as "draw" or "no new drawing, because …".
- CHECK [spec-texts]: Every visible string is written or marked "copy
  needed".
