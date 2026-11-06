# Adwar (أدوار): roles

Each folder is one agent role. A role says **who** the agent is: its mission,
duties, boundaries, the skills it uses (from [`../skills/`](../skills/)), and how
it decides. Skills say **how** a job is done; roles say **who** does it and
where they stop.

Roles are written as `SKILL.md` files, so Claude Code and Cursor load them the
same way as skills (`/ceo`, `/cto`). `scripts/init-project/bootstrap-mac.sh`
links this folder alongside `skills/`.

| Role | Mission |
|------|---------|
| [`ceo`](ceo/SKILL.md) | Challenge business decisions: value, market fit, unit economics |
| [`cto`](cto/SKILL.md) | Challenge technical decisions before building; protect the codebase |
| [`client-ceo`](client-ceo/SKILL.md) | Coordinate one client's project: route tasks, keep context apart, Omar approves deliveries. Paste-in text: [`PROJECT-INSTRUCTIONS.md`](client-ceo/PROJECT-INSTRUCTIONS.md); status in [`../clients/`](../clients/) |

## Writing a role

Keep each role to these sections, in this order:

1. **Mission**: one or two sentences.
2. **Duties**: what it does.
3. **Boundaries**: what it never does, and what needs Omar.
4. **Skills it uses**: names from `../skills/`, never copies of them.
5. **Decision rules**: how it chooses, and when it asks.

A role names skills; it does not repeat their steps. Shared rules (safeguards,
quality baseline) live in `monjizeen/monjizeen-core` and are linked, not copied.
