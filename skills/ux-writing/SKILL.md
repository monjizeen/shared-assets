---
name: ux-writing
description: >
  Write or fix the words inside a product (buttons, labels, errors, empty
  states, alerts, banners, notices, onboarding, confirmation and email texts)
  in Arabic and English, in the product's voice and length limits. Use for
  "microcopy", "UX writing", "texts for the screen", "error messages",
  "alert and banner texts", "notification text", "نصوص الواجهة",
  "صياغة الرسائل".
---

# UX writing

Our method for the words in an interface. Each string has one job: help the
user act. Marketing copy is a different job (`copywriting-ar-en`).

Read [../ux-common/UX-STANDARDS.md](../ux-common/UX-STANDARDS.md) first.

## Before you start

1. Get the product's voice and glossary (the words it already uses for its
   things). If there is no glossary, build a short one from the live
   product; if that is not reachable, from the brief's own words, and mark
   the voice "unverified". Note any rule on **where a word may appear**
   ("only the modal names the supplier") and follow it.
2. Get each string's **place and limit**: the component (button, banner,
   alert title), the max characters or lines, and the languages the product
   ships (the table's language columns come from here). With no limits
   given, use these and label them assumed (English characters; a
   `{placeholder}` counts as its longest real value): button 24, field
   label 30, toast 60, title 50, helper or error line 90, banner body 140,
   option or card body 160, alert or modal body 200.
   When the brief says the texts already exist somewhere you cannot open (a
   prototype, a doc), write proposals anyway, mark the delivery Draft, and
   add "compare with <source>" to Facts to confirm.
3. Get the **facts** behind each message (dates, fees, what happens next,
   what the user can do). Never invent a date, fee, deadline or policy:
   facts you don't have become `{placeholders}` and go in "Facts to
   confirm". Wording is different: you may propose wording, marked
   *proposed*.
4. **Existing strings**: strings the product already has, or the client
   already validated, are marked *reuse* and kept word for word; suggest a
   change only as an alternative. A plain spelling or grammar fix to an
   existing string is *proposed (fix)*, shown with the original.
5. **States you can't reach** (behind a quota, a login or a send): read the
   strings from the product's public front-end files or translation files
   when they are there, mark them "seen in code, not rendered", and say so
   in the status line. Assumed limits only flag a fit *risk*, never a bug,
   for strings that already render on the live product.

## How to do it

1. **One table, one row per string**: key, where it shows, when it shows,
   the job, one column per shipped language, character count per language,
   and reuse or proposed.
2. **Write for the action**: what happened, why it matters to the user,
   what to do now. Front-load the key word. One idea per sentence.
3. **Buttons** say the action ("Order a new card", "اطلب بطاقة جديدة"),
   never "OK", "Submit" or "Yes" when the action can be named. The same
   action has the same word everywhere. When the client's ticket names a
   button differently, the client's word goes in the table and your better
   label goes in Alternatives.
4. **Errors**: say what went wrong in plain words and how to fix it; no
   codes, no blame, no "Oops".
5. **Empty states**: what this place is for and the first action.
6. **Alerts and notices**: the title carries the message alone; the body
   adds the date, the consequence and the choice.
7. **Arabic is written, not translated**: natural Modern Standard Arabic,
   the product's register, neutral gender (UX-STANDARDS §5), the product's
   digits and date format. Check that the Arabic fits the same component.
8. **Fit test**: put the longest version in the real component (Figma or
   HTML) at phone width. With no component to open, mock the component in
   HTML at its known width, or list the strings most at risk. Note any
   string that needs the design to change.
9. **Variants**: for a key message, give one alternative and say how it
   differs, so the client can choose. An alternative keeps the original's
   facts, order and conditions ("first… then…" stays a sequence; "send one
   of them" stays one).
10. **Every language before proposing**: look for each shipped language of
    a string (live page, front-end and translation files) before calling it
    missing or writing a new one.
11. **Count characters with a script**, per language, as the user sees
    them: no markup, diacritics not counted, placeholders at their longest
    real value. The fit mock shows those real values, not `{placeholders}`.
    List shipped strings as fit issues only when they visibly break.

## Output

```
Status: … / Inputs used: … / Not opened: …
# Texts: <feature>
## Voice and glossary used
## Strings (| Key | Where / when | Source (URL, file or key) | <each shipped language> | Original if changed | Chars | Reuse / proposed | Note |)
## Alternatives for key messages
## Fit issues (strings that need a design change)
## Facts to confirm
```

## Quality checks

The shared checks in UX-STANDARDS (ux-states means every state has its
text; ux-a11y means button and link texts make sense out of context) plus:

- CHECK [ux-copy-facts]: Every date, fee, deadline and consequence comes from
  the brief; none is invented.
- CHECK [ux-copy-action]: Every button names its action; every error says how
  to recover.
- CHECK [ux-copy-glossary]: The product's own words are used, the same word
  for the same thing everywhere.
- CHECK [ux-copy-fit]: Every string fits its component limit in every
  language, or is listed as a fit issue.
- CHECK [ux-copy-arabic]: The Arabic reads as written by a native writer,
  neutral in gender, in the product's register and digits (N/A when the
  product has no Arabic).
- CHECK [ux-copy-where]: Every rule on where a word may appear is followed.
- CHECK [ux-copy-status]: Every string is marked reuse or proposed, with its
  source, and changed strings show their original.
- CHECK [ux-copy-meaning]: Every rewrite and alternative keeps the original's
  facts, order and conditions.
