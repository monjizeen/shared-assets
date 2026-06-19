---
name: pre-mvp-audit
description: Structured pre-launch codebase audit that maps the core user loop, then reviews for P0 blockers, scale risks, dead code, security issues, and MVP scope discipline. Use when user says "audit this codebase", "pre-MVP review", "is this ready to ship", "what should we cut", or "technical due diligence".
---

## Project Audit (Pre-MVP / Pre-Scale)

### When to use

* "audit this codebase"
* "pre-MVP review"
* "what should we cut"
* "is this ready to ship"
* "technical due diligence"

---

## Required Inputs (ask if missing)

* **Goal**: MVP launch / post-launch hardening / client handover
* **Core loop (1 sentence, required)**:
  Format → `<actor A> does X → <actor B> does Y → system produces Z`
* **Scope**: full repo or specific modules
* **Stack** (optional): e.g. Laravel + Filament + Vue

If core loop is missing → STOP and ask. Do not proceed.

---

## Phase 1 — Discovery (shallow map, no judgments yet)

Read in this order:

1. README / docs
2. Routes (web/api)
3. Main models + relationships
4. Migrations (focus on money, time, ownership)
5. Controllers / Actions (entry points)
6. Frontend entry (pages/components if applicable)

Output (keep under 150 words):

* Main entities
* Core flows
* Architecture shape
* Anything immediately suspicious

---

## Phase 2 — Audit (deep dive)

Use [CHECKLIST.md](CHECKLIST.md).

Rules:

* Read-only. No fixes, no code.
* Ignore cosmetic issues unless they affect:

  * correctness
  * scale
  * core loop usability
* Every finding must include:

  * **file path + line range**
  * **why it matters in this project**
* No generic advice (e.g. "add tests")

---

## Severity Definitions

* **P0 (Critical blocker)**
  Breaks core loop, risks money/data loss, or exposes auth/security

* **P1 (High)**
  Will cause major issues at real usage (≈100–1k users)

* **P2 (Medium)**
  Worth fixing but does not block MVP

---

## Output Contract (strict)

Produce a Markdown report with:

1. Executive summary (5–8 blunt bullets)
2. Critical blockers (P0)
3. Scale & architecture risks
4. Cut from MVP (ruthless, tied to core loop)
5. Refactor candidates (keep, clean up)
6. Dead code / garbage (delete)
7. UX issues by persona (derived from core loop actors)
8. QA findings (edge cases, ordering, failure modes)
9. Security & data integrity issues
10. Prioritized action list (P0 → P1 → P2)

If a section has nothing → write "None found."

---

## Constraints

* No hedging, no padding
* No praise unless it affects risk
* Tie everything back to the **core loop**
* Prefer concrete failure scenarios over abstract critique

---

## Stop Conditions

If repo is too large:

1. Do discovery
2. Identify top 3–5 risk areas
3. Deep dive only those

Do not fake coverage.
