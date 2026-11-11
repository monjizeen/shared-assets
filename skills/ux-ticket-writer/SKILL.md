---
name: ux-ticket-writer
description: >
  Write design tasks and epics for a design team or a client's tracker
  (Jira, Linear, the Monjizeen app): the problem, why now, scope, inputs,
  the deliverable and a definition of done a reviewer can tick, split into
  tasks of the right size. Use for "create tickets", "write the epic",
  "create tasks for the epic", "review the tickets", "كتابة تذكرة",
  "تجهيز وصف المهمة".
---

# UX ticket writer

Our method for writing design work so someone else can pick it up and finish
it without a meeting. A good ticket is short, specific and checkable.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.

## Before you start

1. **Match the client's ticket format.** Read up to 3 recent tickets of the
   same type (the brief's examples count; say when they are of another type,
   e.g. design tickets used for developer work) in their tracker and copy their headings, title prefixes
   (`[Component][Mobile]`, `Research:`), labels and language. Their format
   beats ours. When their tickets are free prose with no headings, keep
   their title style, language and tone, and put our parts as short bold
   labels inside the prose (see the Arabic labels below).
2. Collect the inputs the work needs: Figma nodes, related tickets, the
   decision or meeting the work comes from, API or backend notes. When an
   input does not exist yet, write `link needed: <what>` in the ticket and
   carry on; it goes in the open questions. A related ticket you only
   inferred is marked "(related? to confirm)".

## How to do it

1. **Title**: in the client's pattern (their prefix and platform suffix, or
   none if they use none); says what is made, not "work on X".
2. **Problem** (2–4 sentences): what the user or team cannot do today and
   what that costs. Facts only, with links.
3. **Why now**: the decision, deadline or dependency.
4. **Scope**: In and Out, as short lists. Out matters as much as In.
5. **Inputs**: every link, each with one line on what it is.
6. **Deliverable**: the exact artefact and where it lives ("Figma frames on
   page X of file Y", "a decision table in the doc").
7. **Definition of done**: 3–8 checkable lines (states, platforms, roles,
   reviewers). Each can be ticked yes or no.
8. **Open questions**, each with who answers.
9. **Size**: one ticket is one deliverable a person can finish in 1–3 days.
   Fixes much smaller than that may stay one per ticket when the brief asks
   for it or the team ships them separately; otherwise group small fixes to
   the same screen or file into one ticket with a checklist.
   Split bigger work into an epic with child tickets in build order, and
   say which can run in parallel. When the size can't be known (the list of
   templates or components doesn't exist yet), make the first child ticket
   the inventory, and label any split you guessed as an assumption.
   Every child ticket names its parent epic.
10. **Reviewing someone else's ticket**: check it against steps 1–9 and
    return the missing parts as suggested text, not just "unclear".

## Arabic section labels

For Arabic tickets use: **المشكلة**، **لماذا الآن**، **النطاق** (يشمل /
لا يشمل)، **المدخلات**، **المخرج المطلوب**، **معايير الإنجاز**،
**أسئلة مفتوحة**، **المهمة الأم**، **تعتمد على**، **الجهد** (size, in
the client's unit, else days; one unit throughout). In Arabic tickets write
the placeholder as «رابط مطلوب: <ما هو>» and refer to source findings with a
term that doesn't clash with the product's own words (e.g. «البند 3 من
المراجعة», not «الملاحظة 3» when the product has «ملاحظات»).

**Definition of done** in a small fix ticket lists only the states and
languages the change touches (e.g. "Arabic and English at 390 px, focus
state"), not the whole states table.

**Validation tickets** (tests, analytics checks): a baseline measure comes
before the fixes it measures; a user test of a fix comes after it. A
baseline from past analytics is tied to a measurement period that ends
before the fixes' release, not to a place in the build order.

**Blocking questions**: every question marked blocking also appears in that
ticket's «تعتمد على» line and in the dependency map, as "← answer to Qn".
A ticket partly blocked says which part.

**The epic** cites its sources like any ticket: each fact in its problem
names the finding it comes from.

**Paste mechanics**: say what goes in Summary and what goes in Description;
no HTML or Markdown wrappers the tracker would paste as literal text.
Tickets that touch the same code but stay separate say so in one line
("same file as T4; ship together").

## Output

Two parts, kept apart:

1. **Notes for us** (not pasted): status and inputs line, the job restated,
   assumptions, open questions at epic level.
2. **Paste-ready tickets**: each ticket's text exactly as it will go into
   the tracker. For an epic: the child tickets in order, then the
   dependency map as a list: `T2 ← T1` (T2 needs T1), and
   `T3 ∥ T4` (can run in parallel). T-numbers are working ids: add one line
   telling the client to replace them with tracker keys after creation.

Before handing over, check every cross-reference ("see T3", "uses the list
from T4") points to a ticket that exists and agrees with the dependency map.

## Quality checks

The shared checks in UX-STANDARDS (ux-states, ux-rtl and ux-a11y apply only
as definition-of-done lines for screen work) plus:

- CHECK [tkt-format]: Title prefix, headings and language follow the client's
  existing tickets.
- CHECK [tkt-problem]: The problem is stated with facts and links, no
  invented numbers.
- CHECK [tkt-scope]: In and Out are both listed.
- CHECK [tkt-dod]: Every definition-of-done line can be ticked yes or no.
- CHECK [tkt-size]: Each ticket is one deliverable of 1–3 days; bigger work
  is split.
- CHECK [tkt-inputs]: Every input is linked with a one-line description, or
  marked `link needed`.
- CHECK [tkt-deps]: Every cross-reference exists and the dependency map
  matches what each ticket says it needs.
