---
name: social-media-graphic
description: >
  Design social media post and ad graphics (single posts, carousels, stories,
  ad creatives) for Instagram, Snapchat, TikTok, X, LinkedIn, Facebook and
  WhatsApp, in Arabic, English or both, following the client's brand. Use when
  someone asks for "a post design", "social graphic", "ad creative", "story
  design", "carousel", "Ramadan post", "National Day post", "تصميم بوست",
  "تصميم إعلان", or any static visual for social media.
---

# Social media graphic

Our method for static social graphics: posts, carousels, stories and ad
creatives. This skill is about the **picture**. Captions and ad text are a
separate job (the copywriting skills); if the task needs both, do the picture
here and hand the words over, or write them only if the brief gives you the
message.

## Before you start

1. **Get the client context.** Read the task brief from `client-context-brief`
   (or run `monjizeen brief --ticket <id>`). You need: logo files, colours,
   fonts, language, tone, rules, the client's QA list, and approved past pieces.
2. **No kit, no guessing.** If logo, colours or language are missing, ask. Don't
   pick brand colours from a screenshot without saying so, and never redraw a
   logo.
3. **Confirm the deliverable** in one line before designing: platform, size,
   count, languages, deadline, and whether they want the editable source. Sizes
   are in [SIZES.md](SIZES.md).
4. **One post, one message.** If the brief has three messages, ask which one
   leads, or propose a carousel.

## How to make it

Pick the route by what you have. In every route, **text is set as real text in
a design tool or HTML, never painted by an image generator.** Image generators
break Arabic letters (disconnected, reversed, made-up shapes) and misspell
English.

| Route | Use when | How |
|---|---|---|
| **Figma** | Figma is connected, or the client wants an editable file | Build on a frame at the exact size, with the client's styles. Export PNG. |
| **HTML to PNG** | No design tool, or many variations from one layout | One HTML file per layout with CSS variables for colours and fonts, rendered at the exact size with Playwright (`page.screenshot`). The browser shapes Arabic correctly. |
| **Canva** | The client works in Canva and will edit it themselves | Use their brand kit; share the edit link. |
| **Image generator** | Only for a background, product scene or texture | No text in the prompt. Put the image under the layout and add text on top. |

### Steps

1. **Pick the job of the graphic.** Announce, offer, educate, prove (review,
   number, result), or celebrate (occasion). The job decides the layout:
   - Offer: the offer is the biggest thing, then the product, then the CTA.
   - Educate: a strong title, a few short points, carousel if more than 3.
   - Prove: the quote or number is the hero, the source is clearly shown.
   - Occasion: the greeting and brand, calm and respectful, little selling.
2. **Sketch 2–3 directions** as quick low-detail versions (layout, not polish).
   Vary the layout or the image idea, not just the colour. Show them if the
   client reviews concepts; otherwise pick the strongest and say why in one
   line.
3. **Set the grid.** Margins of at least 6% of the width on every side (about
   64 px on a 1080 px canvas). Keep inside the platform's safe zone
   ([SIZES.md](SIZES.md)).
4. **Build the hierarchy.** Three levels at most: headline, one supporting line,
   CTA or logo. The headline is readable on a phone held at arm's length: on a
   1080 px canvas, Arabic headlines usually 64–96 px, body text at least 36 px.
5. **Type.** Client fonts first. Arabic rules are in
   [ARABIC-DESIGN.md](ARABIC-DESIGN.md): no letter spacing, more line height,
   right alignment, real Arabic fonts.
6. **Colour.** Client colours only, plus neutrals. Text over images gets a
   solid panel, a gradient or a darkened image so it stays readable. Small text
   needs a contrast ratio of at least 4.5:1; large headlines at least 3:1.
7. **Logo.** Same corner, same size across a client's posts, with the clear
   space from the kit. In Arabic layouts the logo usually sits top right or
   bottom left, mirrored from English, unless the kit says otherwise.
8. **Bilingual posts.** One language leads (bigger, first in reading order). Do
   not squeeze the same long sentence in both languages; shorten both or make
   two versions.
9. **Carousels.** Slide 1 is the hook and must make sense alone. Same margins,
   type sizes and logo spot on every slide. Last slide is the CTA. Slide order
   follows the lead language. Swipe direction can feel backwards to Arabic
   readers, so add a clear swipe cue or slide numbers and keep each slide
   self-contained.
10. **Variations.** For ads, make at least 2 versions that differ in one thing
    (image, headline or layout) so the client can test, and name what differs.
11. **Export.** PNG for graphics with text, JPG (quality 85–90) for photo-heavy
    ones, sRGB colour, exact pixel size. Name files
    `<client>_<platform>_<topic>_<size>_v<n>.png`, e.g.
    `noorapp_instagram_ramadan_1080x1350_v1.png`.

## Standards for MENA work

- **Occasions.** Ramadan, Eid al-Fitr, Eid al-Adha, Saudi Founding Day (22
  February), Saudi National Day (23 September), UAE National Day (2 December),
  and the client's own dates. Ramadan and Eid dates move each year with the
  Hijri calendar: check the date, don't assume. Greetings are warm and short;
  keep the offer secondary or leave it out.
- **Religious content.** Don't use Quran verses, the word Allah, or mosque
  images as decoration. Only use them if the client asks and the use is
  respectful.
- **Flags and national symbols.** Never alter, crop or recolour a national flag
  or emblem. The Saudi flag carries the Shahada: don't put it on a commercial
  graphic unless the client asks and confirms it's allowed for their use.
- **People.** Modest clothing; follow the client's photo rules on who appears.
  No alcohol, gambling or dating cues. Avoid hand gestures that read badly in
  the region.
- **Prices.** In Saudi Arabia, prices to consumers include 15% VAT; say so if
  the kit requires it. The Saudi Riyal has its own symbol (since 2025). Use it
  only if the font supports it or as the official artwork; otherwise write
  `ر.س` or `SAR`, as the kit says. Never mix symbols in one post.
- **Numbers and dates.** Follow the kit: Western or Arabic-Indic digits,
  Gregorian or Hijri. Phone numbers and prices are never split across lines.

## Deliver

Send, in one message:

1. The final files at the exact sizes (and the editable link or HTML source if
   asked).
2. One line per file: what it is and where it goes.
3. Any choice you made that the brief didn't cover ("used the white logo because
   the photo is dark").
4. Open questions, if any.

## Quality checks

Run every check before delivery. Report each as PASS, FAIL or UNKNOWN (with
why).

- CHECK [gfx-size]: Every file is the exact pixel size for its placement, and
  key content sits inside the safe zone.
- CHECK [gfx-brand]: Only the client's logo files, colours and fonts are used;
  the logo has its clear space and isn't stretched or recoloured.
- CHECK [gfx-one-message]: Each graphic has one main message that reads in under
  3 seconds on a phone.
- CHECK [gfx-text-real]: All text is real text set in a design tool or HTML, not
  painted by an image generator.
- CHECK [gfx-arabic]: Arabic letters are connected and in the right order, no
  letter spacing, right aligned, no broken words at line ends.
- CHECK [gfx-spelling]: Spelling, names, prices, phone numbers, links and dates
  match the brief exactly, in every language.
- CHECK [gfx-contrast]: Text contrast is at least 4.5:1 for small text and 3:1
  for headlines, including text over images.
- CHECK [gfx-culture]: Nothing breaks the MENA standards above (occasions,
  religious content, flags, people, prices).
- CHECK [gfx-client-qa]: Every item on the client's own QA list passes.
- CHECK [gfx-files]: Files are named by the pattern and exported as PNG or JPG
  in sRGB.
