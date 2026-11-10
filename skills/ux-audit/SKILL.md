---
name: ux-audit
description: >
  Review the usability of a live product, staging build, prototype or Figma
  file and hand back a ranked list of problems with concrete fixes. Use for
  "UX audit", "usability review", "review the dashboard", "test the user
  experience", "مراجعة تجربة المستخدم", "اختبار تجربة الاستخدام", "review the
  website", or a design review of a page someone else built.
---

# UX audit

Our method for finding what makes a product hard to use and saying exactly
what to change. The output is a ranked findings list, not a redesign.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.
Template in monjizeen-core: `notes/ux/templates/audit.md` (repeated below).

## Before you start

1. Get the brief and the client context (UX-STANDARDS §1).
2. **Pin the scope in one line**: product, the user role you act as, the
   journeys, platforms and languages. A dashboard audit "from the content
   editor's view, entry to publish" is a scope; "review the system" is not.
   If the brief limits the kind of change (for example "only fonts, labels,
   fields and spacing, no feature changes"), that limit is a rule: every
   recommendation must fit inside it.
3. **Pick 2–4 key journeys** from the brief (the tasks users come for). If
   the brief names none, take the product's main job and say so.

## How to do it

1. **Walk each journey as the user**, step by step, at phone width (390 px)
   and desktop (1440 px), in each language the product ships. Use realistic
   data: long names, Arabic and English, an empty account, a wrong input.
   Take a screenshot of every problem as you find it.
2. **Break it on purpose**: try empty and wrong inputs (client-side
   validation only), go back mid-flow, reload, open a deep link logged
   out, try keyboard only, zoom to 200 %. **On a live production site never
   send a form** that creates data or contacts people (questions, sign-ups,
   emails, payments); on staging with a test account you may. When a
   journey is blocked (a quota, a login wall, a step that would send
   data), go as far as is safe, record where and why it stopped, and list
   the rest as not reviewed.
   Write down the date, time and time zone of the walk; quotas, content and
   banners change.
3. **Sweep the lenses** after the walk (UX-STANDARDS §3): heuristics,
   WCAG essentials, Arabic/RTL (§5), states (§4). Measure contrast and target
   sizes rather than guessing (browser dev tools or a contrast checker on the
   real colours).
4. **Write one finding per problem**: where (exact screen, element, state,
   width, language), what happens, why it matters (the user's goal, a
   heuristic or a WCAG criterion), the fix, severity 1–4, effort S/M/L, and
   confidence (*seen*: reproduced; *signal*: likely, needs data to prove).
   Merge duplicates; split a finding that hides two problems. One cause in
   several places (the same colour failing on buttons and titles) is one
   finding with every place listed, unless the places need different
   fixes.
5. **Make every fix concrete and small**: name the element, the change and
   the new value or text. Take values from the client's design system, or,
   with none, from the product itself (a colour it already uses that
   passes), and say where it came from ("Move 'نشر' to the top bar of the editor, primary
   style", "Raise the label to 14 px and contrast to 4.5:1"). When the brief
   allows code-level advice, give the CSS or HTML change.
6. **Rank**: severity first, then how many users and how often, then effort.
   Number the findings after ranking, then name the screenshots by those
   numbers. When a blocker has a workaround, rate it 3 and say why. Pick up
   to five quick wins (high impact, S effort).
7. **Keep what works**: two to four strengths the fix list must not break.
8. **Say what would raise confidence**: a 5-user test of journey X, an
   analytics check on step Y. Never present your walk as user research.

## Output

```
Status: … / Inputs used: … / Not opened: … / Walked on: <date, time, zone>
# UX audit: <product>, <scope>
## Summary          2–4 sentences: state, top 3 problems, the one change with the most impact
## Scope and method role, journeys, widths, languages, lenses; what was out of scope
## Findings         | # | Sev | Where | Issue | Why it matters | Fix | Effort | Confidence |
## Quick wins       up to 5, by number
## Strengths to keep
## Next steps       validation that would raise confidence
## Assumptions and open questions
```

Attach the screenshots, named by finding number. Turn it into a client page
with `notes/design/visual-pages.md` when the client reads pages; embed the
screenshots it shows as base64 `data:` images (keep them cropped and
compressed, under about 200 KB each) so the page stays one file.

## Standards for MENA work

- Audit the Arabic version as a first-class product, not a translation:
  mirroring, mixed text, digits, line height and truncation (UX-STANDARDS §5).
- Religious and charity products: check that honorifics and verses render
  intact, and that donation amounts, fees and receipts are always visible
  before confirming.
- Note where an English-first pattern does not fit (a left-swipe to delete
  that is a right-swipe in RTL, an English-only search that misses Arabic
  spelling variants such as ة/ه and أ/ا).

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [audit-journeys]: The key journeys are named and each was walked end
  to end; findings say which journey and step they come from.
- CHECK [audit-severity]: Every finding has severity 1–4 and effort S/M/L,
  and the table is sorted by severity.
- CHECK [audit-fix]: Every finding has a concrete fix that names the element
  and the change; no "improve the UX".
- CHECK [audit-limits]: Every fix fits the limits in the brief (no feature or
  structure changes when the brief rules them out).
- CHECK [audit-screens]: Each finding of severity 2 or more has a screenshot
  or a Figma node link.
- CHECK [audit-quick-wins]: Quick wins and strengths to keep are listed.
