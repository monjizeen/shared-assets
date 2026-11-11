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
   or type, what it holds, how much of it, who it is for. Count one URL per
   row; a row that stands for several pages says how many, and pages found
   outside the sitemap are counted separately ("29 in the sitemap + 2
   found by crawling").
2. **Audiences from evidence**: segments come from the brief, the client's
   research or analytics. If none exist, use behavioural segments
   ("first-time visitor curious about X") and mark them as assumptions. No
   invented personas.
3. **The user's words**: what users call things. Sources, best first: the
   client's search logs and analytics, support or chat first messages,
   reviews, competitors' labels, then the site's own FAQ (labelled
   "site-written", weakest). Ask for the first two if they exist. Internal
   names are flagged.
4. **Crawl from the sitemap** (`/sitemap.xml`, `/wp-sitemap.xml`) in the
   background when it is large, and record for each page its inbound links,
   the element that carries each one (logo, breadcrumb, menu, body link)
   and whether they are visible. Check that each nav label goes to one
   target everywhere (two "Home" links to two pages is a finding). Clusters of pages that never link to each
   other, hidden menus and dead links are findings.

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
   One action, one label everywhere, and one label, one target.
7. **Priority per audience**: for each audience, what the home page or entry
   leads with and the path to their goal in 3 steps or fewer (clicks from
   the home page, the final action click included).
8. **Validation plan**: tree test tasks or a card sort, who to recruit,
   what success looks like. Defaults unless the client has better: tree
   test with 15–20 people per audience, success when 80 % find the right
   place and directness is 70 % or more; open card sort with 15 people,
   success when the proposed top-level groups match how at least 60 % of
   people group the cards. Tree-test tasks describe the goal without the
   words of any node on the path to the answer, the destination's title
   included; an always-visible button outside the tree is
   tested with a first-click test on the page instead.
   For a small brochure site the nav rules can be short; write "N/A: <why>"
   for a rule that cannot apply.

## Output

```
Status: … / Inputs used: … / Not opened: …
<the job in three lines>
# IA: <product>
## Top findings (| # | Sev 1–4 | Finding | Where | Fix |), most severe first
## Goals and audiences (with sources)
## Content inventory and audit (| Item | Audience | Linked from (visible?) | Keep/merge/rewrite/move/remove | Why |)
## Calls to action (| Label | Page | Goes to |), from the crawl, not by eye
## Gaps and orphans (ranked)
## Organisation scheme
## Structure (tree)
## Navigation model and rules
## Labels (| Label | Covers | Why | Rejected |)
## Priority per audience
## Validation plan
## Assumptions and open questions (who answers; blocking first)
```

Lower the validation defaults only with a stated reason.

## Accessibility in IA work

Where the site exists, check the navigation itself: every nav item and
main call to action is reachable by keyboard (a real link or button, not a
`role="button"` with no `href` or `tabindex`), menu buttons have labels,
focus order follows the visual order, and in Arabic the nav order mirrors.
Never call accessibility N/A when a live site was crawled.

## Standards for MENA work

When the site lacks a language its audience needs (an Arabic audience on an
English-only site), say so as a finding and give labels in that language as
proposals.

- Arabic labels are short, plain and in the product's register; check them
  in the nav at phone width, where Arabic can wrap badly.
- Search and nav must handle Arabic spelling variants (ة/ه, ى/ي, أ/إ/ا,
  with or without diacritics).
- For religious and da'wah sites, separate content for Muslims and for
  people new to Islam, and never lead non-Muslim visitors with internal
  community terms (da'wah, revert, terms of worship in Arabic without a
  gloss). Honorifics (SWT, PBUH, ﷺ), Quran and hadith are never proposed
  for removal: propose a gloss, and ask the client. Calls to convert ("Become a Muslim") are a client decision of
  tone and placement: propose, show where it sits, and ask.

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
- CHECK [ia-validation]: A tree test or card sort plan is included, with a
  success number for each.
- CHECK [ia-one-target]: Each nav label goes to one target everywhere; the
  inventory names the element behind each inbound link.
- CHECK [ia-a11y]: The nav and main calls to action were checked for keyboard
  reach and labels (N/A only when there is no live site).
