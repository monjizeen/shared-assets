---
name: information-architecture
description: >
  Structure a site's or product's content and navigation: what goes where,
  what it is called, the navigation rules, and which content to lead with
  for each audience. Use for "sitemap", "navigation", "menu", "naming",
  "labels", "content structure", "audience segments", "what to show on the
  site", "شريط التنقل", "هيكلة المحتوى", "المسميات", "دراسة محتوى الموقع".
---

# Information architecture

Our method for deciding where content lives and what it is called, so users
find what they came for. The output is a structure with reasons, not a list
of pages.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.
Template in monjizeen-core: `notes/ux/templates/ia.md`.

## Before you start

1. **Inventory the content that exists**: crawl the site (Playwright or the
   sitemap), the CMS content types, or the product's screens. A table: page
   or type, what it holds, how much of it, who it is for.
2. **Audiences from evidence**: segments come from the brief, the client's
   research or analytics. If none exist, use behavioural segments
   ("first-time visitor curious about X") and mark them as assumptions. No
   invented personas.
3. **The user's words**: what users call things (search terms, support
   questions, competitors' labels). Internal names are flagged.

## How to do it

1. **Goals**: what each audience comes to do, and what the business needs
   them to do. One line each.
2. **Content audit**: for each item, keep, merge, rewrite, move or remove,
   with why. Flag gaps (a need with no content) and orphans (content no
   path reaches).
3. **Organisation scheme**: task, audience, topic or time; name it and say
   why it fits.
4. **Structure**: an indented tree, at most 3 levels unless needed.
5. **Navigation model**: global nav (5–7 items; on mobile, a bottom bar of
   3–5 for apps), utility nav, footer, in-page links. When navigation is
   built automatically from content (a site builder, a theme), write the
   **rules**: which item appears when, the order, the limit, and what
   happens when there are too many or none.
6. **Labels**: table of label, what it covers, why, alternatives rejected.
   One action, one label everywhere.
7. **Priority per audience**: for each audience, what the home page or entry
   leads with and the path to their goal in 3 steps or fewer.
8. **Validation plan**: tree test tasks or a card sort, who to recruit,
   what success looks like.

## Output

```
# IA: <product>
## Goals and audiences (with sources)
## Content inventory and audit (| Item | Audience | Keep/merge/rewrite/move/remove | Why |)
## Gaps and orphans
## Organisation scheme
## Structure (tree)
## Navigation model and rules
## Labels (| Label | Covers | Why | Rejected |)
## Priority per audience
## Validation plan
## Assumptions and open questions
```

## Standards for MENA work

- Arabic labels are short, plain and in the product's register; check them
  in the nav at phone width, where Arabic can wrap badly.
- Search and nav must handle Arabic spelling variants (ة/ه, ى/ي, أ/إ/ا,
  with or without diacritics).
- For religious and da'wah sites, separate content for Muslims and for
  people new to Islam, and never lead non-Muslim visitors with internal
  community terms; check the tone of every label with the client.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [ia-inventory]: The structure rests on an inventory of real content,
  not on a guess of what exists.
- CHECK [ia-audiences]: Every audience has a source or is marked as an
  assumption; no invented personas.
- CHECK [ia-labels]: Every top-level label is in the users' words, and
  internal jargon is flagged.
- CHECK [ia-nav-rules]: Navigation has written rules for limits, order and
  the too-many and none cases.
- CHECK [ia-paths]: Each audience reaches its main goal in 3 steps or fewer,
  shown in the structure.
- CHECK [ia-validation]: A tree test or card sort plan is included.
