---
name: qa-reviewer
description: >
  Review a piece of agent work before Monjizeen delivers it: check it against
  the brief, the org's context, the service skill's CHECK items, the client's
  custom skills and what we learned from past feedback, then pass it or flag
  each issue. Learns from our feedback through LEARNINGS.md. Use before every
  `deliver`, and when someone says "QA this", "review before delivery",
  "check the work".
---

# QA reviewer

Monjizeen has no human reviewers. This skill is the check every delivery
passes before the client sees it. Run it as a fresh pass: read the work as
the client would, not as the agent that made it.

## Inputs

- The request: brief, input links, earlier deliveries and feedback
  (`get_request`).
- The org's context (`get_org_context`).
- The service skill's **Quality checks** (`CHECK [key]:` lines).
- The client's custom skills (`clients/<client>/skills/`), if any.
- [LEARNINGS.md](LEARNINGS.md): what we taught this reviewer.

## How to review

1. **Brief first.** Does it do what was asked, for whom, in the languages and
   sizes asked? List anything missing.
2. **Every CHECK.** Report each service CHECK as PASS, FAIL or UNKNOWN, with
   one line of evidence. UNKNOWN means you could not tell; say what you'd
   need.
3. **Client rules.** Their context and custom skills: brand, tone, words to
   avoid, what they liked and disliked before. A repeat of past client
   feedback is always a FAIL.
4. **Learnings.** Apply each line in LEARNINGS.md that fits this service.
5. **Safety.** No secrets or keys, no other client's name or work, no public
   links, no made-up facts or numbers (every number has a source).
6. **Rate it.** Score 1–5 on four dimensions (monjizeen-core
   `notes/ux/quality-rubric.md`), each with one line of why:
   - **Complete**: every part of the brief and the skill's template is there
     and substantive.
   - **Accurate**: every claim is right or marked as an assumption; nothing
     invented.
   - **Specific**: every item names the exact screen, element, step or case.
   - **Fits the client**: their audience, words, rules and limits.
   **Great** = QA PASS and every score 4 or 5 with an average of at least
   4.5. Only great work goes to a client review or a skill's test flight
   sign-off.

## Output

```
QA: PASS | FAIL    Rating: complete x/5, accurate x/5, specific x/5, fits x/5 (avg x.x) → great | good | not yet
- CHECK [key]: PASS|FAIL|UNKNOWN: evidence
- Brief: …
- Client rules: …
Flags: one line per issue, most important first, each with the fix.
```

Any FAIL means fix and review again. Deliver only on PASS, or with the
remaining UNKNOWNs named in the delivery note as questions.

## Learning from us

When we (the Monjizeen team) disagree with a review, or a client flags
something the reviewer passed:

1. Write one line in LEARNINGS.md: the service (or `all`), what to check,
   and why. Never a client name or client fact: those go to that client's
   custom skill through the `feedback-auditor`.
2. If a learning keeps coming up for a service, propose it as a new CHECK in
   that service skill (we review the change first).
