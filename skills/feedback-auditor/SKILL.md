---
name: feedback-auditor
description: >
  Sort every piece of client feedback on a Monjizeen delivery into
  client-specific (goes to that client's custom skill), global (a best
  practice that should update the main service skill or the QA reviewer), or
  disagree (bad advice we should not follow), and propose the change for each.
  Nothing changes a skill until we review the sorting. Our decisions train it
  through DECISIONS.md. Use when feedback arrives on a request, or when
  someone says "audit feedback", "sort the feedback", "what did the client
  flag".
---

# Feedback auditor

Clients answer each delivery with `send_feedback` (approved, or
changes_needed with notes). Their notes are how our skills get better. This
skill sorts them; **we decide**.

## Sort each point

Split the notes into separate points. For each one, pick one bucket:

| Bucket | Means | Proposed change |
|---|---|---|
| **Client-specific** | How this client likes things: their brand, tone, taste, rules | Add to `clients/<client>/skills/<service>/SKILL.md` (create it if missing) |
| **Global** | A best practice that would make the work better for every client | Edit the main service skill (`skills/<service>/`) or add a line to `qa-reviewer/LEARNINGS.md` |
| **Disagree** | Bad advice: against good practice, accessibility, law, or the client's own goals | No skill change. Draft a short, polite reply that explains and offers what we can do |
| **Unclear** | Can't tell what they mean | Draft one question back to the client |

Most feedback is client-specific. Call it global only when it would help a
different client with a different brand. When unsure between the two, pick
client-specific.

Also note whether the **QA reviewer should have caught it**. If yes, propose
a LEARNINGS.md line.

Read [DECISIONS.md](DECISIONS.md) first: follow how we decided similar
points before.

## Output (for our review)

```
Request <id> · <service> · <client>
1. "<their words>"
   Bucket: client-specific | global | disagree | unclear (confidence: high/medium/low)
   Why: one line
   Proposed: the exact text to add, and the file; or the reply to send
   QA should have caught it: yes/no
```

Then **stop**. Show it to the Monjizeen team. Change no skill, send nothing.

## After we decide

1. Apply only what we approved, exactly as approved (commit in
   shared-assets; a global skill change goes through a PR).
2. Log every point in DECISIONS.md: your bucket, our bucket, and a one-line
   reason when we changed it. This is how the auditor learns. Write it
   without client names or client facts (say "a client" and describe the
   pattern).
3. Redo the work for the request if it was changes_needed (the
   `agent-requests` skill), now with the updated skills.
