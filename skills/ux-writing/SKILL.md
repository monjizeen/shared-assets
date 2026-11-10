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
   product and use it.
2. Get each string's **place and limit**: the component (button, banner,
   alert title), the max characters or lines, and the languages.
3. Get the **facts** behind each message (dates, fees, what happens next,
   what the user can do). Never invent a date, fee, deadline or policy.

## How to do it

1. **One table, one row per string**: key, where it shows, when it shows,
   the job, English, Arabic (and other languages shipped), character count
   per language.
2. **Write for the action**: what happened, why it matters to the user,
   what to do now. Front-load the key word. One idea per sentence.
3. **Buttons** say the action ("Order a new card", "اطلب بطاقة جديدة"),
   never "OK", "Submit" or "Yes" when the action can be named. The same
   action has the same word everywhere.
4. **Errors**: say what went wrong in plain words and how to fix it; no
   codes, no blame, no "Oops".
5. **Empty states**: what this place is for and the first action.
6. **Alerts and notices**: the title carries the message alone; the body
   adds the date, the consequence and the choice.
7. **Arabic is written, not translated**: natural Modern Standard Arabic,
   the product's register, neutral gender (UX-STANDARDS §5), the product's
   digits and date format. Check that the Arabic fits the same component.
8. **Fit test**: put the longest version in the real component (Figma or
   HTML) at phone width. Note any string that needs the design to change.
9. **Variants**: for a key message, give one alternative and say how it
   differs, so the client can choose.

## Output

```
# Texts: <feature>
## Voice and glossary used
## Strings (| Key | Where / when | Job | EN | AR | Chars EN/AR | Note |)
## Alternatives for key messages
## Fit issues (strings that need a design change)
## Facts to confirm
```

## Quality checks

The shared checks in UX-STANDARDS plus:

- CHECK [ux-copy-facts]: Every date, fee, deadline and consequence comes from
  the brief; none is invented.
- CHECK [ux-copy-action]: Every button names its action; every error says how
  to recover.
- CHECK [ux-copy-glossary]: The product's own words are used, the same word
  for the same thing everywhere.
- CHECK [ux-copy-fit]: Every string fits its component limit in every
  language, or is listed as a fit issue.
- CHECK [ux-copy-arabic]: The Arabic reads as written by a native writer,
  neutral in gender, in the product's register and digits.
