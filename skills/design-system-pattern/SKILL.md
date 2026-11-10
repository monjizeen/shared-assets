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
3. A pattern rests on real cases: collect at least 5 real instances from the
   product (screens, Figma nodes) before writing a rule.

## How to do it

1. **Purpose**: one sentence, what problem this item solves.
2. **Anatomy**: the parts, named, required or optional.
3. **Variants and sizes**: each with when to use it.
4. **States**: default, hover, pressed, focus, disabled, loading, error,
   selected, read-only, as they apply (components); empty, loading, partial,
   error (organisms and templates).
5. **Decision table** (patterns always; others when there is a choice):
   rows = the closed list of cases, columns = what to use and why. Cases
   come from the instances you collected; mark any case you could not find
   a real example for.
6. **Instance matrix**: the real uses found, each mapped to the rule, with
   the ones that break it flagged as fixes for the product.
7. **Do and don't**: 2–4 pairs, each from a real case.
8. **Content rules**: label length, casing, truncation, numbers, icons.
9. **Accessibility**: roles, focus order, target size, screen reader text,
   motion.
10. **RTL and languages**: what mirrors, what does not, the longest-language
    case.
11. **Related items** and the line between them ("a bottom sheet, not an
    alert, when the user must choose from more than two options").
12. **For AI generators** (when the client uses one): the rule written as
    short, testable lines the generator can follow.

## Output

```
# <Level>: <Name>
## Purpose
## Anatomy
## Variants
## States
## Decision table           (| Case | Use | Why |)
## Instance matrix          (| Where (screen / node) | Case | Follows rule? | Fix |)
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
  instance (screen or node) or is marked as having none.
- CHECK [ds-closed-list]: The decision table covers every case in the brief's
  catalogue, each with one answer.
- CHECK [ds-boundaries]: The item's line with related items is stated.
- CHECK [ds-states]: Every state that applies is listed and drawn or linked.
- CHECK [ds-format]: The doc follows the client's existing format and level
  names.
- CHECK [ds-testable]: Each usage rule can be checked yes or no on a screen.
