# Client task

How one client task moves from request to delivery. The rules behind each step
are in [`../roles/client-ceo/SKILL.md`](../roles/client-ceo/SKILL.md); this file
only shows the order and the hand-offs.

**Trigger:** a client asks for a finished piece of work (a page, a design, a
fix, a document).

| # | Who (role) | Does | Uses | Hands off |
|---|---|---|---|---|
| 1 | `client-ceo` | Writes the requirements down | — | Requirements, to Omar |
| 2 | Omar | Approves the requirements | — | **Gate 1** |
| 3 | `client-ceo` | Opens one thread for the task, with client, task, requirements, where context lives, skills to use, what "done" is | — | Thread brief |
| 4 | Thread agent | Builds the task brief from the client's context | `client-context-brief`, monjizeen-core rules and checks | One-page brief |
| 5 | Thread agent | Does the work | The service skill (see [`../skills/SERVICES.md`](../skills/SERVICES.md)); `cto` for technical plans; `start-work` / `finish-work` for code | Result + `CHECK` results (PASS, FAIL, UNKNOWN) |
| 6 | `client-ceo` | Puts the result in front of Omar with a short summary and what was checked | — | Delivery, to Omar |
| 7 | Omar | Approves the delivery; only then does it go to the client | — | **Gate 2** |
| 8 | `client-ceo` | On feedback: free redo within the requirements; a useful lesson becomes a GitHub issue proposing a rule | — | Rule issue, to Omar |
| 9 | Omar | Approves the rule; it lands in monjizeen-core or this repo (general) or the client's context (client only) | — | **Gate 3** |

Throughout, `client-ceo` keeps `clients/<client>/STATUS.md` current.

**Done:** Omar approved the delivery, it reached the client, and any feedback
is either fixed or filed as a rule issue.
