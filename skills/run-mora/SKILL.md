---
name: run-mora
description: >
  Turn MORA on — single bootstrap with zero setup. Syncs mora, shared-assets,
  studios, installs Cursor hooks/rules/skills and Claude Code skills + studios.
  Use when user says run mora, start mora, /run-mora, turn on mora, bootstrap mora,
  first time setup, new mac, or sync everything. Replaces manual install steps.
disable-model-invocation: true
---

# Run MORA

**One command. No memorization.** Run immediately — do not ask the user to run steps manually.

## Execute now

From the mora repo (or pass mono root if known):

```bash
bash "$(git -C "${workspace}" rev-parse --show-toplevel 2>/dev/null || echo ~/Documents/work/monjizeen-dev/mora)/run-mora.sh"
```

If workspace is not mora, try these in order until one exists:

1. `./run-mora.sh` when cwd is inside a mora clone
2. `~/Documents/work/monjizeen-dev/mora/run-mora.sh`
3. `~/Documents/work/projects/monjizeen-dev/mora/run-mora.sh`
4. Parent of cwd if folder is named `mora` and contains `run-mora.sh`

Optional: `--all-repos` to clone every app repo listed in REGISTRY.

## What it does (automatic)

| Step | Action |
|------|--------|
| 1 | Clone/pull **mora**, **shared-assets**, **studios** |
| 2 | Write **~/.cursor/mono-root** + **mora-hub** (hooks find your layout) |
| 3 | Install **Cursor** hooks, rules → `~/.cursor/` |
| 4 | Symlink all skills from **shared-assets/skills/** → `~/.cursor/skills/` and `~/.claude/skills/` |
| 5 | Install **Claude Code** studios → `~/.claude/` |
| 6 | Report ready |

## After

- Open Cursor on any repo under the mono root — MORA routes via hooks
- Re-run `/run-mora` after `git pull` on another Mac (or daily)
- For UI studio work: `invoke-studio.sh` or interactive `claude` + `/frontend`

Exit **0** → tell user "MORA is ready." Exit **1** → show `need` lines from script output.

Restart Cursor or start a new chat if hooks were just installed.
