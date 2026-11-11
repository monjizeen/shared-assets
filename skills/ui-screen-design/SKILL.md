---
name: ui-screen-design
description: >
  Design app and web screens (dashboards, settings, forms, lists, detail
  pages, editors, landing sections) from a brief or spec, as Figma frames or
  hi-fi HTML, with every state, both languages and both widths. Use for
  "design the screen", "design the dashboard", "UI design", "mockups",
  "تصميم واجهات", "تصميم شاشة", "تصميم لوحة تحكم", "convert wireframes to
  designs", "finalize the design".
---

# UI screen design

Our method for designing screens people can build. The picture is the
deliverable, but the thinking behind it (hierarchy, states, reuse) is what
the client pays for.

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.
For a feature that has no spec yet, run `ux-feature-spec` (short form) first.

## Before you start

1. **Design system first.** Find the client's library (Figma library,
   component docs, tokens, an existing product). Use their components,
   tokens and type scale. With no library, take the tokens from the live
   product (measure them, UX-STANDARDS §2) and say so; ask only if there is
   no product either. Never invent brand colours.
   When a client token fails WCAG AA where you need it (white text on a
   light brand green), keep the token for its other uses, use the nearest
   passing shade from their palette for that use, and list it as a
   proposal for the client.
   When the brief asks for Figma but no library or file is reachable, use
   the HTML route and say in the status line that the Figma version is
   pending access.
2. **Look at the existing product** around the new screen, **in each
   language it ships** (draw each language's header, nav and words from that
   language's live version, never by translating the other): header, nav,
   patterns already used for lists, drawers, forms. The new screen must look
   like it belongs there.
   When the new screens hand off to an existing flow (sign-in, ask, pay),
   carry over that flow's rules, branding, limits and wording (quotas,
   excluded topics, opening hours, the account's name) and list them.
   Note the product's form of address (formal plural, neutral) and keep it.
   Diff the header and nav of each language item by item; items that exist
   in only one language are kept there. States that change with time (quota
   windows, opening hours) are recorded with when you saw them, never as
   "the live site shows only X".
3. **Confirm the deliverable** in one line: screens, platforms and widths,
   languages, states, Figma or HTML, editable source or not.

## How to do it

1. **Purpose per screen**: who is here, what they came to do, the one
   primary action.
2. **Content first**: list the blocks top to bottom in priority order and
   why each sits there. Cut what does not serve the job (no dashboard soup:
   at most one hero metric row, then what the user acts on).
3. **Low-fi first**: 2 layout options as grey boxes when the layout is not
   given, saved with the delivery (`00-lowfi-a.png`, `00-lowfi-b.png`).
   Pick one and say why in one line (or show both if the client reviews
   concepts).
4. **Build hi-fi** with the client's components:
   - Figma route: load `figma-use`, work in the client's file on a new page
     or a copy, use library components and variables, auto layout, real
     text.
   - HTML route: one file, CSS variables for tokens, real text in each
     language, rendered with Playwright at 390 and 1440 px (and the
     product's own breakpoints).
5. **Real content**: real-looking text in each shipped language, long
   names, big numbers, many and zero items. No lorem ipsum, no placeholder
   avatars of real people. Sample text reads like real content, never like
   a note about testing ("long title to test wrapping"). **Religious, legal and medical content is never
   made up as if real**: no invented fatwas, verses, hadith, rulings or
   reference numbers. **Prefer real published items from the client's own
   product** (real titles, numbers and links, copied exactly); only when
   none fit, mark sample text clearly on the screen. A sample query shows
   the real results for that query, or results tagged as samples, never real
   items that did not come from it (a `[نص تجريبي]` / `[Sample]` tag and
   numbers like `00000`). Legal texts the brief asks for (a disclaimer)
   are drafted as proposals for the client's legal or religious board.
6. **Every state** the screen can be in (UX-STANDARDS §4), drawn, not
   described. Forms: each field's default, focus, filled, error, disabled
   (one states sheet for fields and buttons is enough). An error message
   sits directly under its field, and the sheet's error state shows the
   message. The primary action named in the note is the most prominent
   button on the screen; when a hand-off copies several live filled
   buttons, say which is primary and why. When a note rule ("the ask band
   is secondary when results exist") meets a state that needs the opposite
   (weak matches), write the exception into the rule itself, and draw
   every screen to the rule as written. Any hint that points somewhere
   ("the options below") must have that thing on the same screen.
   **How much to draw**: every screen and state in the lead language at both
   widths; the second language at both widths for the key screens (entry,
   main result, main error) and at phone width for the rest.
7. **RTL**: a mirrored Arabic frame for every screen when the product ships
   Arabic, checked against §5, not just flipped.
8. **Accessibility pass**: contrast on real colours, 44 px touch targets on
   mobile, visible labels, focus order noted.
9. **Annotate**: numbered notes on any non-obvious choice, the components
   used, and anything new that the design system does not have yet. In
   Figma, a notes frame beside the screens; in HTML, an annotated copy of
   the key screens with numbered pins and a legend.
10. **Hand-off check**: frames named `<Screen> / <State> / <Lang> / <Width>`
    (HTML and PNG files: `NN-screen__state__lang__width.png`; one responsive
    HTML file per screen and state, the width only in the PNG name), organised in
    one place with an index page, and the design note listing them.
11. **Fonts in HTML**: use the client's web font when it can be loaded;
    otherwise the closest free font (Google Fonts, saved next to the HTML)
    and say which stands in for which.

## Output

- The frames (Figma link to the page) or the HTML files plus PNGs.
- A short design note:
  ```
  Status: … / Inputs used: … / Not opened: …
  ## Screens (name, purpose, primary action)
  ## Decisions (numbered, one line each, with why)
  ## States drawn (| Screen | States |)
  ## Components (library ones used; new ones needed)
  ## Proposals for the client (token changes, drafted legal text)
  ## Assumptions and open questions (each: who answers, blocks or not; blocking first)
  ```

## Standards for MENA work

- Arabic-first products are designed in Arabic first and then checked in
  English, not the other way round.
- Use the client's Arabic font; if none, suggest from
  `social-media-graphic/ARABIC-DESIGN.md` and ask.
- Religious content (verses, hadith, honorifics) is set exactly and given its
  own style; never decorative.

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [ui-system]: Only the client's components, tokens and type scale are
  used; anything new is listed as new.
- CHECK [ui-fit]: The screen matches the product's existing header, nav and
  patterns.
- CHECK [ui-primary]: Each screen has one clear primary action and a
  hierarchy that reads in 5 seconds.
- CHECK [ui-states-drawn]: Every state is drawn, not just described.
- CHECK [ui-real-content]: Real-looking content in each language, including
  long and empty cases; no lorem ipsum.
- CHECK [ui-rtl-frames]: A checked Arabic frame exists for every screen when
  the product ships Arabic.
- CHECK [ui-handoff]: Frames are named and organised, and the note lists
  decisions, states and components.
- CHECK [ui-proposals]: Every colour, token or text the client does not have
  (focus, success, error background, a disclaimer) is listed under
  Proposals for the client.
- CHECK [ui-each-language]: Each language's chrome and words match that
  language's live product.
- CHECK [ui-lowfi]: Low-fi options are saved with the delivery (or the brief
  gave the layout).
- CHECK [ui-consistent]: No screen contradicts itself or the note (query vs
  result heading, an error away from its field).
