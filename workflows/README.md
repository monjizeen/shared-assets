# Masarat (مسارات): workflows

Each file is one workflow: how roles (from [`../roles/`](../roles/)) and skills
(from [`../skills/`](../skills/)) work together on a process, from the first
request to the finished result.

| Workflow | What it covers |
|----------|----------------|
| [`client-task.md`](client-task.md) | One client task, from request to Omar's approval and feedback |

## Writing a workflow

One file per process, with:

1. **Trigger**: what starts it.
2. **Steps**: numbered; each names the role doing it and the skill it uses.
3. **Hand-offs**: what passes from one step to the next, and where it is kept.
4. **Omar's gates**: the points where Omar must say yes.
5. **Done**: what finished looks like.

A workflow points to roles and skills by name. Their details stay in their own
files, so a change is made once.
