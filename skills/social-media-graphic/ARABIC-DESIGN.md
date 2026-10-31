# Arabic in visual design

Rules for any graphic with Arabic text. Most of these are where generic tools
and non-Arabic designers go wrong.

## Letters

- Arabic letters connect. Check every word: no gaps between letters that should
  join, no letters in reverse order, no isolated forms in the middle of a word.
- **Never let an image generator draw Arabic text.** Set it in Figma, Canva or
  HTML. Paste text from a source the client approved, don't retype.
- Don't use apps or fonts that don't shape Arabic (some older design tools
  show broken letters). If the preview looks disconnected, the export will be
  too.
- No letter spacing (tracking) on Arabic. It breaks the joins. To make a word
  longer for style, use a font with kashida (ـ) support, and only in headlines.

## Fonts

Use the client's font. If they have none, suggest one of these free, well-made
families and ask:

| Feel | Fonts |
|---|---|
| Modern, clean | IBM Plex Sans Arabic, Readex Pro, Noto Sans Arabic, Almarai |
| Friendly, rounded | Tajawal, Cairo, Rubik (Arabic) |
| Traditional, formal | Noto Naskh Arabic, Amiri, Noto Kufi Arabic |

- Pair an Arabic font with a Latin one of similar weight and height (or use one
  family that covers both, like IBM Plex or Noto).
- Arabic looks smaller than Latin at the same size. Set Arabic about 10–20%
  larger when both appear side by side, so they look the same.
- Avoid very thin weights for anything under headline size; Arabic dots and
  marks disappear on phones.

## Layout

- Read right to left. Align Arabic text to the right. The reading path starts
  top right, so the most important thing goes there or in the centre.
- Mirror English layouts for Arabic: logo, arrows, step order and progress
  indicators flip. Don't mirror logos, product photos, clocks, or numbers.
- Line height about 1.5–1.8 for body text (Arabic has tall letters and marks
  above and below). Headlines about 1.2–1.4.
- Don't break a word or a name across lines. Don't leave one short word alone
  on the last line.
- Mixed Arabic and English in one line: check that numbers, brand names and
  punctuation land in the right place. In HTML, set `dir="rtl"` and `lang="ar"`
  on the Arabic block.

## Numbers, dates, currency

- Follow the client kit: Western digits (123) or Arabic-Indic (١٢٣). One style
  per graphic.
- Phone numbers and prices stay on one line and read left to right inside
  Arabic text.
- Dates: Gregorian, Hijri or both, as the kit says. Check Hijri dates against a
  real calendar.
- Saudi Riyal: the official symbol (2025), `ر.س`, or `SAR`, as the kit says.
  Check the font actually has the new symbol before using it as text.

## Language style

- Modern Standard Arabic for formal or official pieces; Saudi or Gulf everyday
  Arabic only if the kit says so. Never mix the two in one graphic.
- Don't translate English slogans word for word. Ask the copywriter or the
  client for an Arabic line that says the same thing naturally.
