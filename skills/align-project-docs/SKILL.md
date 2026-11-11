---
name: align-project-docs
description: >
  Keep a project's description, its brief (context) in the Monjizeen app and its
  GitHub README telling the same story, and create projects in the app through
  the Monjizeen MCP. Use when adding a project or product, writing or changing
  what a product is, editing a README's opening, or when someone says "align
  the docs", "add a project", "update the brief".
---

# Align project docs

The same facts used to live in three places and drift: the project description
in the Monjizeen app, the project's context in the app, and the README on
GitHub. Each kind of fact now has **one owner**.

| Fact | Owner | Others |
|---|---|---|
| What the product is, who it is for, goals, what it is not | **Project Brief** (the project's context in the app) | README links to it; never repeats it |
| One-line description | **First line of the Project Brief** | Same line opens the README, and is the app's description |
| How to run, build, test and change the code | **README** in the repo | The brief does not repeat it |
| Decisions, notes | The project's `decisions` and `notes` docs in the app | |

## Rules

1. **Brief first.** When the product changes, change the brief, then the README's
   opening line to match. Never the other way round.
2. **One line.** The description is a single sentence a stranger understands.
3. **Read before you write.** Before describing a product, read what already
   exists: the brief in the app, the repo README, the business notebook
   (`monjizeen-business` decisions) and earlier threads. Never guess a
   description. If nothing exists, ask once, then write it down.
4. **Names match.** Same product name in the brief, README and app. Arabic name
   in brackets after the English one on first use.
5. **Internal vs client.** A brief for an internal product says who may use it.
   A brief for a client project never names another client.

## Brief shape

```
<One-line description.>

<Two or three sentences: what it does, and how it differs from nearby products.>

## Goals
## Audience
## Constraints
```

## Create a project in the app (Monjizeen MCP)

Agents use the MCP, never the database. With a key that may reach the org:

1. `get_org_context` (admin keys add `organization_id`) lists the org's
   projects, so you do not duplicate one.
2. `create_project` with `name` and a one-line `description`. Same name again
   is safe: nothing is duplicated.
3. Write the full brief: `PUT /api/projects/{id}/contexts/project-brief` with
   `{"content": "..."}`, following the shape above.
4. Make the repo README's opening line the same sentence.

Org agents (a client's own agent) only reach their own org. The Monjizeen team's
admin key reaches all of them. Keys are never pasted into chat, commits or docs.

## Check before you finish

- Brief first line, README opening and app description are the same sentence.
- The brief says what the product is **not**, if a neighbour could be confused
  with it.
- No keys, no other client's name anywhere.
