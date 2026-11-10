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
   tokens and type scale. If there is none, ask; if they say "none", use a
   neutral 4/8 px spacing system and say so. Never invent brand colours.
2. **Look at the existing product** around the new screen: header, nav,
   patterns already used for lists, drawers, forms. The new screen must look
   like it belongs there.
3. **Confirm the deliverable** in one line: screens, platforms and widths,
   languages, states, Figma or HTML, editable source or not.

## How to do it

1. **Purpose per screen**: who is here, what they came to do, the one
   primary action.
2. **Content first**: list the blocks top to bottom in priority order and
   why each sits there. Cut what does not serve the job (no dashboard soup:
   at most one hero metric row, then what the user acts on).
3. **Low-fi first**: 2 layout options as grey boxes when the layout is not
   given. Pick one and say why in one line (or show both if the client
   reviews concepts).
4. **Build hi-fi** with the client's components:
   - Figma route: load `figma-use`, work in the client's file on a new page
     or a copy, use library components and variables, auto layout, real
     text.
   - HTML route: one file, CSS variables for tokens, real text in each
     language, rendered with Playwright at 390 and 1440 px (and the
     product's own breakpoints).
5. **Real content**: real-looking Arabic and English text, long names, big
   numbers, many and zero items. No lorem ipsum, no placeholder avatars of
   real people.
6. **Every state** the screen can be in (UX-STANDARDS §4), drawn, not
   described. Forms: each field's default, focus, filled, error, disabled.
7. **RTL**: a mirrored Arabic frame for every screen when the product ships
   Arabic, checked against §5, not just flipped.
8. **Accessibility pass**: contrast on real colours, 44 px touch targets on
   mobile, visible labels, focus order noted.
9. **Annotate**: numbered notes on any non-obvious choice, the components
   used, and anything new that the design system does not have yet.
10. **Hand-off check**: frames named `<Screen> / <State> / <Lang> / <Width>`,
    organised in one place, a cover note listing them.

## Output

- The frames (Figma link to the page) or the HTML files plus PNGs.
- A short design note:
  ```
  ## Screens (name, purpose, primary action)
  ## Decisions (numbered, one line each, with why)
  ## States drawn (| Screen | States |)
  ## Components (library ones used; new ones needed)
  ## Assumptions and open questions
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
