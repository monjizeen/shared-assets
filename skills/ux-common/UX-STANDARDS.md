# UX standards (shared by every UX skill)

Every UX service skill (`ux-audit`, `design-qa`, `ux-feature-spec`,
`ui-screen-design`, `design-system-pattern`, `information-architecture`,
`ux-writing`, `ux-ticket-writer`) reads this file first. It holds what they
all share; each skill holds only its own method.

Long reference notes live in monjizeen-core: `notes/ux/frameworks.md`,
`notes/ux/anti-patterns.md`, `notes/ux/quality-rubric.md`,
`notes/ux/templates/*.md` and `notes/design/visual-pages.md`. The essentials
are repeated here so a skill works without them.

## 1. Before you start

1. **Read the brief and the client context.** The task brief from
   `client-context-brief` (or `monjizeen brief --ticket <id> --tags ux`) and,
   for agent requests, `get_request` and `get_org_context`. When you were
   handed brief files instead (a test flight, a pasted ticket), those files
   are the brief and the context; do not go looking for the tools. Client
   rules (design system, product words, languages, who reviews) come from
   there, never from memory.
2. **Open every input before writing a word.** Figma links (Figma MCP:
   `get_design_context`, `get_screenshot`, `get_metadata`), live or staging
   pages (Playwright, phone width 390 px and desktop 1440 px, in each language
   the product has), tickets and comments, docs and sheets.
3. **List what you cannot open, all at once, in one message.** "I need: view
   access to Figma file X, a staging login, the Jira comment on Y." Do not
   start half-blind and do not ask one question at a time. If the work can
   still start on what you have, start, and mark what is pending.
   **Missing inputs change the status, not the effort**: deliver what you
   can, label the delivery `Draft: waiting on <inputs>` at the top, and mark
   every item that rests on an unseen input as a proposal. Never fill the
   gap from imagination.
4. **Match the client's words to the real thing.** When the brief names a
   screen, block or term ("the period screen", "the ring"), find the exact
   frame, node or page it means. If you cannot tell, write your reading as
   an assumption and a question that **blocks** the work until answered.
5. **Restate the job in three lines** before you start: who the user is, what
   they are trying to do, and what the deliverable is (format, scope,
   platforms, languages). If the brief does not say, pick the most likely
   reading and write it as an assumption. These three lines go right under
   the status line of the delivery.
6. **The skill's Output block wins** over the headings of any Core template
   it borrows from.

## 2. Evidence rules (break one and the work fails QA)

- **Never invent evidence.** No made-up user quotes, numbers, analytics,
  research results, screens you did not see, or rules the client never gave.
- **Every claim points to its source**: a screenshot, a URL, a Figma node, a
  ticket line, a heuristic or WCAG criterion. A number with no source is
  removed.
- **Guesses are labelled.** Write "Assumption: X, because Y" in the
  assumptions list, never "users probably…".
- **Saw it or didn't.** Say exactly what you reviewed (pages, states, widths,
  languages, logged in or out). Anything you could not reach is listed as out
  of scope, not reviewed from imagination.
- **Name the exact place.** "Search results page, filter chip row, 390 px",
  not "the filters".
- **Cite sources the same way every time**: a URL (with the width and
  language), a Figma file name + node id (`444:11774`) + a screenshot, or a
  ticket line quoted in "…". A rule, finding or decision with no source is
  either removed or marked "Proposal".
- **Proposal vs settled.** Anything the client already decided (in the
  ticket, a doc, a Figma note) is *settled* and quoted. Anything you decide
  is a *proposal* and labelled so, with one line of why. Never present your
  own wording, rule or number as the client's.
- **Measure, don't eyeball.** Colours, sizes, spacing and letter spacing are
  read from the build (`getComputedStyle` in Playwright) or from Figma
  (`get_design_context`), and contrast is computed with the WCAG formula
  (relative luminance), not guessed from a screenshot. [measure.js](measure.js) does both:
  `node ux-common/measure.js <url> "<selector>" 390`.

## 3. Lenses (cite one only to explain a problem)

- **Nielsen's 10 heuristics**: system status; match the real world; user
  control; consistency; error prevention; recognition over recall;
  flexibility; minimalist design; error recovery; help.
- **Severity** for any finding: 4 Critical (blocks the task, loses money or
  data), 3 Major (frequent errors or heavy friction), 2 Minor (workaround
  exists), 1 Cosmetic.
- **WCAG 2.2 AA essentials**: text contrast 4.5:1 (3:1 large text and UI
  parts); targets at least 24×24 px (44–48 px on mobile); everything works by
  keyboard with a visible focus; visible labels, not placeholder only; errors
  in text, not colour only; nothing by colour alone; reduced motion honoured.
- **Laws of UX** when they explain something: Hick (fewer choices, faster
  decisions), Fitts (big, close targets), Jakob (work like the apps people
  know), Miller (chunk), Tesler (someone carries the complexity), peak-end,
  Doherty (feedback under ~400 ms).
- **Jobs to be done**: "When [situation], I want to [motivation], so I can
  [outcome]."

## 4. Every screen has more than one state

A design or review that shows only the happy path is not finished. Check
each that applies:

| State | Ask |
|---|---|
| Default | Typical data, typical length |
| Loading | Skeleton or spinner; what stays usable |
| Empty | First use and "no results"; what to do next |
| Error | Validation, server, network; how to recover |
| Partial | Some data missing (a field the backend may not send) |
| Long content | Long names, big amounts, many items, wrapping |
| Permission | Read-only user, logged out, no access |
| Success | Confirmation and where the user goes next |
| Edge | Zero, one, the maximum; past and future dates |
| Search | Empty query, too short, misspelled, no results, many results (pagination or load more) |

When a feature extends a screen that already exists, still fill each state:
say what the screen does today in that state (seen, with a source) and
whether the new part changes it. "As today" alone is not an answer.

When one element sums up several values (a ring over four limits, a badge
over many items), write which value it shows, the rule for choosing it, and
what it shows when only some values are present.

## 5. Arabic, RTL and MENA

Most generic UX advice forgets these. They apply to every UX skill.

- **Mirroring.** In Arabic the whole layout mirrors: navigation, back
  arrows, progress, steppers, carousels, chevrons, tab order. Do **not**
  mirror: media play buttons, clocks, numbers, charts' time axes (follow the
  product's rule), logos, and icons of real objects (a phone, a checkmark).
- **Mixed text.** Latin words, numbers, emails, IBANs, card numbers and
  phone numbers inside Arabic keep left-to-right order; check they do not
  jump to the wrong end of the line. Amounts with currency follow the
  product's rule; never split a number, amount or phone across lines.
- **Digits and dates.** Western (123) or Arabic-Indic (١٢٣) digits, and
  Gregorian or Hijri dates, follow the product. Never mix in one screen.
- **Type.** No letter spacing on Arabic; more line height (about 1.6–1.8 for
  body); Arabic usually needs a slightly bigger size than Latin to read the
  same; thin weights lose the dots on phones.
- **When the product has no Arabic**, skip this section and say "Arabic/RTL:
  N/A, the product ships <languages>". Still check the longest language the
  product ships (German, Lithuanian and Russian often run 30–40 % longer than
  English) and each currency's format.
- **Length.** Arabic labels are often shorter in letters but taller; English
  and some European languages run much longer. Design for the longest
  language the product ships.
- **Words.** Use the product's own words and its form of address (check
  the live product: "حسابكم" vs "حسابك"); write the choice in the note. Use Modern Standard Arabic unless
  the client asks for a dialect. Formal "you" in sensitive products
  (religion, money). Gender: prefer neutral forms (verb nouns, imperative
  plural or "يمكنك") over guessing the user's gender.
- **Religious content.** Quran verses, hadith and honorifics (ﷺ, عز وجل,
  رضي الله عنه) are shown exactly as given, never cut, restyled as
  decoration, auto-translated or placed where they can be stepped over (a
  footer pattern, a background). Ask before changing how they look.
- **Trust in money products.** Amounts, fees and the final total are always
  visible before the user confirms; irreversible actions say so.

## 6. Working with big Figma files (read only)

1. `create_session`, then `get_screenshot` of the linked node first to see
   what is there.
2. `get_metadata` only on the node you need. When it is large, save it to a
   file in your scratch folder and search it by layer name instead of
   reading it all.
3. Drill into the child nodes you will cite; take a cropped screenshot of
   each one you cite.
4. Real instances of a component are found by searching the metadata for its
   name on the pages that hold shipped screens, not on the master page.
5. Never edit, comment on or move anything in a client file unless the brief
   asks, and then only on a copy or a new page.

## 7. Ways to deliver

Pick by what the client works in; say which you picked.

| Deliverable | Route |
|---|---|
| Figma frames | Figma MCP (`use_figma`, after loading the `figma-use` skill) in the client's file and with their library. Never edit a client's master file: work in a copy or a new page and say where. |
| Clickable or hi-fi screens without Figma | One HTML file per screen set, real text, CSS variables for the client's tokens, rendered with Playwright to PNG at 390 and 1440 px. |
| A review, spec or plan | Markdown that follows the skill's template, and a client page made with `notes/design/visual-pages.md` when the client reads pages. The page may embed the cropped screenshots it needs as base64 `data:` images (under ~200 KB each) and stays one file. |
| Comments on a Figma file or ticket | Only where the client asked for comments there; never post publicly. |

Screenshots in a delivery are cropped to the element they prove and named
`<n>-<where>-<state>.png`, where `<n>` is the number of the finding or row
they prove. One overview image per screen is fine when it helps orient.
Side by side images (build vs design) are composed in a small HTML page and
captured with Playwright.

**Client copy is clean.** The delivery never shows our internals: no
Monjizeen ticket numbers, skill names, CHECK keys, "UX-STANDARDS §3", agent
or model names. Use the client's own ticket keys (e.g. `UIUX-750`) only.
Our QA notes go in a separate file, not in the delivery.

**Every delivery opens with a status line and inputs**:

```
Status: Ready for review | Draft: waiting on <inputs>
Inputs used: <list with links>    Not opened: <list, and what it blocks>
```

## 8. Before you hand over (all UX skills)

- [ ] Followed the skill's template; nothing invented.
- [ ] Every item names its exact place and its source.
- [ ] States covered (section 4), Arabic/RTL covered (section 5).
- [ ] Ranked: the reader knows what matters first.
- [ ] Assumptions and open questions listed at the end, short.
- [ ] Smallest change that solves the problem; no redesign nobody asked for.
- [ ] No marketing words ("seamless", "delightful"); no filler intro.
- [ ] Cross-references inside the delivery all exist (no "see T3" when there
      is no T3) and the flow, rules and tables do not contradict each other.
- [ ] Ran the QA reviewer: read `../qa-reviewer/SKILL.md` and do it as a
      separate, fresh pass on your own delivery (it is a file to follow, not
      a tool), save it as `qa-self-check.md` next to the delivery, and fix
      every FAIL before handing over. A delivery without `qa-self-check.md`
      fails QA.

## Shared quality checks

Every UX skill runs these with its own. A check that cannot apply (no
interface shown, no Arabic in the product) is reported as `N/A: <reason>`,
which is not a FAIL. Each skill lists any shared check it never uses.

- CHECK [ux-evidence]: Every finding, rule or number points to a source the
  client can open (screenshot, URL, Figma node, ticket line, standard); no
  invented users, quotes or data.
- CHECK [ux-scope]: The delivery says exactly what was reviewed or designed
  (screens, states, widths, languages) and what was not.
- CHECK [ux-specific]: Every item names the exact screen, element or step it
  applies to.
- CHECK [ux-states]: Loading, empty, error, partial and long-content states
  are covered wherever a screen is shown or specified.
- CHECK [ux-rtl]: Arabic and RTL rules in section 5 hold wherever Arabic is in
  scope.
- CHECK [ux-a11y]: Contrast, target size, labels, focus and non-colour cues
  are addressed wherever an interface is shown.
- CHECK [ux-ranked]: Items are ranked so the reader knows what comes first:
  findings by severity, specs and tickets by what blocks the work, open
  questions with the blocking ones first.
- CHECK [ux-assumptions]: Every guess is in the assumptions list with its
  reason; open questions for the client are listed, each with who answers
  and whether it blocks the work.
- CHECK [ux-clean]: The delivery opens with its status and inputs line and
  shows none of our internals (our ticket numbers, skill names, CHECK keys).
