---
name: design-system-pattern
description: >
  Document or design a design-system item (component, organism, pattern or
  page template): its anatomy, variants, states, usage rules, a decision
  table for when to use it, do and don't examples, accessibility and RTL
  rules, so designers, developers and AI generators use it the same way. Use
  for "[Component]", "[Pattern]", "[Template]", "[Organism]", "design system",
  "usage rules", "decision table", "نظام التصميم", "مكونات".
---

# Design system pattern

Our method for one design-system item at a time. The goal is a rule anyone
(a designer, a developer, an AI UI generator) can apply without asking:
when to use it, how it looks in every case, and when **not** to use it.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.

## Overlay and screen forms (name them; they are often confused)

| Form | Is | Closes with |
|---|---|---|
| Pushed screen | A new screen in the stack | Back arrow |
| Full-height modal view ("bottom sheet screen") | Covers the screen, slides up | X / Close |
| Partial sheet | Part-height sheet over the screen | Drag down, X, tap outside |
| Alert dialog | Small centred box, 1–2 actions | One of its buttons |
| Action sheet | List of actions from the bottom | Cancel or tap outside |
| Anchored menu | Pull-down list attached to the control that opened it | Tap an item or outside |

Map these to the client's own archetype names in the names table; when one
client name covers two forms ("Bottom Sheet Screen" for partial and full
height), say so.

## Levels

Use the client's own level names if they have them. Otherwise:

| Level | Is | Example |
|---|---|---|
| Component | One control | Button, chip, text area, PIN input |
| Organism | Components that work as one block | Card list, bottom sheet, chat composer |
| Pattern | A rule for a recurring choice | Primary action placement, overlay choice, error display |
| Template | A whole screen layout for a job | OTP screen, success screen, transaction list |

## Before you start

1. **Inventory what exists**: the master library item, work-in-progress
   files, docs, and real uses in shipped screens (search the files for
   instances). Write down where they disagree.
2. Find the **readiness criteria** the client uses (what makes an item
   "ready"), and the format of items already documented. Match it.
3. **Cover the brief's "Applies to" list**: every archetype, organism and
   component it names appears in the doc with its rule.
4. **Acceptance criteria**: list each one of the brief's acceptance
   criteria (quick tests, a Figma matrix page, the readiness checklist) with
   done, not done because <reason>, or N/A: reason. A criterion that needs
   a Figma page while the brief is read only is declared "to build in a
   copy after approval".
5. A pattern rests on real cases: collect at least 5 real instances from the
   product (screens, Figma nodes) before writing a rule. Search the pages
   that hold shipped screens, not the master page (UX-STANDARDS §6). A
   catalogue of finished screens kept in a components or WIP file counts
   as shipped screens; say so in the coverage line. Master
   components with placeholder text are not instances, and a master's
   layout counts (5 demo actions) are not limits. Every instance-matrix row
   carries its node id and a screenshot. A page you name as likely to hold
   instances is opened before delivery; "not opened" is only for pages you
   cannot access. Any client input that an acceptance criterion depends on
   and that you did not open makes the status "Ready for review except
   <input>" (e.g. the readiness checklist on an intranet), and that
   criterion stays open.
6. **When you can't find enough real cases** (no access to the product
   files, or the master is all placeholders), still deliver: label the doc
   `Draft: waiting on instances`, mark every row *settled* (the client
   decided it; quote where) or *proposal* (your rule, with why), and list
   exactly which files would give the instances.
   **How deep to search**: until each case has 2 real instances or you have
   searched the pages most likely to hold it (handoff and shipped-screen
   pages of the main product areas); write the coverage ("8 of 60 Cards
   pages, chosen because …"). Nested instances are captured by rendering
   their parent frame and cropping: the crop offsets are the child's x/y
   inside the parent (from `get_metadata`), since screenshot tools refuse
   `I…;…` ids.
7. **When real screens disagree with a rule** (the generator says "a
   screen", the shipped design uses a sheet; one question drawn two ways),
   the instance matrix flags it and an open question asks which wins; never
   silently pick one. Real cases the brief's catalogue misses are added as
   rows marked "new case, to approve".
8. **Names that disagree** (the ticket says "alert-modal", the master says
   "Alert - Dialog", a doc says "modal"): use the name of the level's
   registry or the ticket, list every alias once in a names table, and ask
   which is canonical.
9. **Settled, proposal or unproven**: *settled* means the client decided
   it (an approved doc, a ticket line). A rule that rests only on an
   unapproved generator rule or a master, with no real instance, is
   *proposal (no instance)*.

## How to do it

1. **Purpose**: one sentence, what problem this item solves.
2. **Anatomy**: the parts, named, required or optional.
3. **Variants and sizes**: each with when to use it.
4. **States**: default, hover, pressed, focus, disabled, loading, error,
   selected, read-only, as they apply (components); empty, loading, partial,
   error (organisms and templates).
5. **Decision table** (patterns always; others when there is a choice):
   rows = the closed list of cases, columns = what to use, why, the
   instance or source behind it, and settled or proposal.
6. **Instance matrix**: the real uses found, each mapped to the rule, with
   the ones that break it flagged as fixes for the product. Test each
   instance against its row's **whole** test and Use cell (the condition,
   and every part it prescribes: ✕, illustration, action count and order),
   not only its form. "Follows" means every part matches; anything less is
   "partly: <what is missing>". An instance that fails the row's condition
   belongs to another row. With a first-match table, test each instance
   against every earlier row too: it belongs to the first row it matches. Instances drawn before a rule was settled (the
   client's to-do still open) are "known migration", listed once, with the
   to-do's node.
7. **Do and don't**: 2–4 pairs, each from a real case.
8. **Content rules**: label length, casing, truncation, numbers, icons.
9. **Accessibility**: roles, focus order, target size, screen reader text,
   motion. When the client gave none, use our defaults (UX-STANDARDS §3 and
   the platform's guidelines: iOS HIG, Material) marked "our default".
10. **RTL and languages**: what mirrors, what does not, the longest-language
    case.
11. **Related items** and the line between them ("a bottom sheet, not an
    alert, when the user must choose from more than two options").
12. **For AI generators** (when the client uses one): the rule written as
    short, testable lines the generator can follow. Each generator rule
    carries its decision row's status (settled, proposal, or "pending Qn");
    a rule never decides an open question.
13. **Consistency pass**: read the anatomy, decision table, generator rules
    and settled client rules side by side. A number (actions, steps) stated
    twice must be the same; no row may break a settled rule (a sheet over
    a sheet); fix or raise a question before handing over.
14. **Applies-to depth**: an archetype in "Applies to" that nothing in the
    catalogue opens still gets one line: what may open over it and how it
    is left. A form named only in an open question is not covered.

## Output

```
Status: … / Inputs used: … / Not opened: …
# <Level>: <Name>
## Purpose
## Names and aliases        (when sources disagree)
## Anatomy
## Variants
## States
## Decision table           (| Case | Use | Why | Source | Settled or proposal |)
## Instance matrix          (| Where (file, page, node id) | Screenshot | Case | Follows rule? | Fix |)
## Acceptance criteria      (| Criterion | Done / not done: why / N/A: why |)
## Do / don't
## Content rules
## Accessibility
## RTL and languages
## Related items
## Generator rules          (if used)
## Open questions
```

Build or fix the Figma master only when the brief asks, and then only in a
branch or copy, never the live library directly.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [ds-real-cases]: Every rule and decision-table row rests on a real
  instance (screen or node) or a quoted client decision, or is marked as a
  proposal; with fewer than 5 real instances the doc is labelled Draft.
- CHECK [ds-closed-list]: The decision table covers every case in the brief's
  catalogue, each with one answer.
- CHECK [ds-boundaries]: The item's line with related items is stated.
- CHECK [ds-states]: Every state that applies is listed and drawn or linked.
- CHECK [ds-format]: The doc follows the client's existing format and level
  names.
- CHECK [ds-testable]: Each usage rule can be checked yes or no on a screen.
- CHECK [ds-applies-to]: Every item in the brief's "Applies to" list and
  every overlay form involved has its rule.
- CHECK [ds-criteria]: Every acceptance criterion of the brief has a status.
- CHECK [ds-instance-fit]: Every "follows" instance meets its row's whole
  test and Use cell; partial ones say what is missing.
- CHECK [ds-consistent]: Anatomy, decision table, generator rules and settled
  client rules do not contradict each other, and every generator rule
  carries its row's status.
