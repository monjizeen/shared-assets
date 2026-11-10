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

1. **Match the client's ticket format.** Read 3 recent tickets of the same
   type in their tracker and copy their headings, title prefixes
   (`[Component][Mobile]`, `Research:`), labels and language. Their format
   beats ours.
2. Collect the inputs the work needs: Figma nodes, related tickets, the
   decision or meeting the work comes from, API or backend notes.

## How to do it

1. **Title**: `<prefix> <thing> — <platform>` in the client's pattern; says
   what is made, not "work on X".
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
   Split bigger work into an epic with child tickets in build order, and
   say which can run in parallel.
10. **Reviewing someone else's ticket**: check it against steps 1–9 and
    return the missing parts as suggested text, not just "unclear".

## Output

The ticket text, ready to paste in the client's format. For an epic: the
epic, then the child tickets in order, then a one-line dependency map.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [tkt-format]: Title prefix, headings and language follow the client's
  existing tickets.
- CHECK [tkt-problem]: The problem is stated with facts and links, no
  invented numbers.
- CHECK [tkt-scope]: In and Out are both listed.
- CHECK [tkt-dod]: Every definition-of-done line can be ticked yes or no.
- CHECK [tkt-size]: Each ticket is one deliverable of 1–3 days; bigger work
  is split.
- CHECK [tkt-inputs]: Every input is linked with a one-line description.
