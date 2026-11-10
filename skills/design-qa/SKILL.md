---
name: design-qa
description: >
  Check what developers built against the approved design, the design system
  and the review comments given earlier, and report what matches, what is
  wrong and what is still missing. Use for "review the implementation",
  "design QA", "check the developers' fixes", "مراجعة التنفيذ", "مراجعة
  التعليقات المنفذة", "مراجعة تحسينات المطورين", "review the new version of
  the app".
---

# Design QA

Our method for checking a build against its design. It answers three
questions for the team: what is done right, what is wrong, and what was never
done. It is not a fresh UX audit; new usability ideas go in a short separate
list at the end.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.

## Inputs (list any you cannot open, all at once)

- The **build**: staging or live URL, app build, or screen recordings, plus a
  test account for each role.
- The **source of truth**: the approved Figma frames (node links) and the
  design system or component library.
- The **earlier comments** if this is a follow-up round: Figma comments,
  ticket comments or the last QA report, with their numbers.

## How to do it

1. **Build the check list first.** One row per thing to check:
   - every earlier comment, keeping its number or link (round 2 and later);
   - every screen and state in the approved frames that is in scope;
   - the design system basics for those screens (type scale, spacing, colour
     tokens, components, icons).
2. **Compare side by side**, same data, same width (390 and 1440 px, plus the
   breakpoint the design has), same language. Screenshot the build next to
   the Figma frame for each mismatch.
3. **Check what designs often leave out**: states (UX-STANDARDS §4), hover
   and focus, long text, RTL mirroring, Arabic fonts and digits, keyboard,
   real data, and the dark theme if the product has one.
4. **Give each row one status**:
   - **Done**: matches the design (or the comment is resolved).
   - **Wrong**: built but differs; say how, with both screenshots and the
     expected value (spacing 16 not 24, token `primary-600`, text "...").
   - **Missing**: not built.
   - **Changed on purpose?**: differs in a way that may be a decision; ask.
   - **Can't check**: no access or the state can't be reached; say why.
5. **Rank the Wrong and Missing rows**: blocks use or breaks the flow
   (High), visible to most users (Medium), polish (Low).
6. **Write each fix for a developer**: the element, the expected value from
   the design, and where it is defined (Figma node, token, component name).
7. **New ideas** that are not in the design go in "Suggestions (not in the
   design)", short, so they never mix with defects.

## Output

```
# Design QA: <product>, round <n>, <date>
## Summary        x done, y wrong, z missing, w can't check; the 3 that matter most
## Scope          build version/URL, frames compared, widths, languages, roles
## Earlier comments   | # | Comment | Status | Evidence | Fix |
## Screens and states | Screen/state | Status | Evidence (build vs design) | Fix | Priority |
## Suggestions (not in the design)
## Can't check, and what is needed
```

When the client works in Figma comments or tickets, post one comment per
Wrong or Missing row in that place (only where the client asked) and keep the
report as the summary.

## Standards for MENA work

- Check the Arabic build against the Arabic frames, not the English ones:
  mirrored layout, font, line height, digits and that icons that should not
  mirror did not.
- Check numbers, amounts, phones and IDs inside Arabic text keep their order.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [dqa-every-comment]: Every earlier comment has a row and a status;
  none is skipped silently.
- CHECK [dqa-evidence]: Every Wrong row has the build screenshot and the
  design reference (Figma node or token) side by side.
- CHECK [dqa-expected]: Every Wrong row states the expected value, not just
  "doesn't match".
- CHECK [dqa-statuses]: Only the five statuses are used and the summary
  counts match the tables.
- CHECK [dqa-separate]: New ideas are in the Suggestions list, not mixed with
  defects.
