---
name: refresh-mora
description: >
  Full monjizeen sync — mora infra, hooks, studios, skills, plus clone any new
  app repos from REGISTRY and pull all registry repos up to date. Use when user says
  refresh mora, sync mora, /refresh-mora, new mac, switch device, or sync all repos.
disable-model-invocation: true
---

# Refresh MORA

**Device switch / daily full sync.** Run immediately — do not ask the user to run steps manually.

## Execute now

```bash
bash "$(git -C "${workspace}" rev-parse --show-toplevel 2>/dev/null || echo ~/Documents/work/projects/monjizeen/mora)/scripts/refresh-mora.sh"
```

If workspace is not mora, try these in order until one exists:

1. `./scripts/refresh-mora.sh` when cwd is inside a mora clone
2. `~/Documents/work/projects/monjizeen/mora/scripts/refresh-mora.sh`
3. `~/Documents/work/projects/monjizeen/mora/scripts/refresh-mora.sh`

Equivalent: `run-mora.sh --all-repos`

## What it does (vs `/run-mora`)

| Step | Action |
|------|--------|
| 1 | Clone/pull **mora**, **shared-assets**, **studios** |
| 2 | **Clone** any missing app repo from REGISTRY |
| 3 | **Pull** every existing registry app repo (ff-only) |
| 4 | Install Cursor hooks/rules + symlink skills + Claude studios |

`/run-mora` alone skips steps 2–3 (hooks/skills only). Use **refresh** when switching Macs or after new repos land in REGISTRY.

Exit **0** → "MORA synced — all repos up to date." Exit **1** → show `need` lines (dirty tree, merge conflict, etc.).

See `shared-assets/skills/run-mora/SKILL.md` for path fallbacks and hook details.
