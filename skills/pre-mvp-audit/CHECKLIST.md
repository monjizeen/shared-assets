## Audit Checklist (Laravel / Filament / Vue-leaning, adaptable)

### 1. Core Loop Integrity

* Can the loop complete end-to-end without:

  * manual DB fixes
  * hidden steps
  * role confusion
* Any step that can dead-end?

---

### 2. Data & Money Safety

* Money stored as float?
* Missing transactions on multi-step writes?
* Partial writes possible?
* No audit trail for:

  * payments
  * approvals
  * edits

---

### 3. Auth & Authorization

* Missing policies / gates?
* Policies defined but not enforced?
* Mass assignment issues (`$fillable` / guarded)?
* Cross-tenant data leakage?

---

### 4. Query & Scale Risks

* N+1 in tables/lists (common in Filament)
* Missing indexes on:

  * foreign keys
  * status fields
  * timestamps used in queries
* Heavy queries in loops
* No caching where obvious

---

### 5. Architecture Smells

* Fat controllers / god classes
* Business logic in views/components
* Duplicated logic across services
* Tight coupling blocking iteration

---

### 6. Dead Weight Detection

* Unused:

  * routes
  * controllers
  * models
  * migrations
* Commented-out blocks
* Half-built features
* Tutorial leftovers

---

### 7. MVP Scope Discipline

Flag anything not directly supporting the core loop:

* dashboards with no decisions
* notifications without actions
* analytics before usage exists
* role systems beyond necessity

---

### 8. UX Breakpoints

Simulate:

* new user
* confused user
* malicious user

Check:

* empty states
* unclear next steps
* blocking errors
* missing confirmations

---

### 9. QA-in-a-Bad-Mood

* What if user:

  * skips steps?
  * double-clicks actions?
  * submits twice?
  * loses connection mid-action?
* Race conditions?
* Validation gaps?
* State inconsistencies?

---

### 10. Frontend / Inertia / Vue

* Components doing API calls instead of proper flow?
* State duplication?
* Overloaded shared props?
* Broken loading/error states?

---

### 11. Evidence Rule

Every finding must include:

* file path + line range
* concrete failure scenario OR observed pattern

No exceptions.
