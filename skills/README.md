# monjizeen-dev Skills (single source of truth)

All custom skills live here — versioned on GitHub. **Do not edit copies** under `~/.claude/skills/` or `~/.cursor/skills/`.

## Skills

| Skill | Purpose |
|-------|---------|
| `start-work` | Sync main (QUICK) or confirm branch (WORKTREE); challenge scope before coding |
| `finish-work` | Test, commit, push when done — no auto PR or merge |
| `cleanup` | Sync main, prune branches, clean local git state |
| `cto` | Review technical decisions, architecture, code quality |
| `ceo` | Review business decisions, unit economics, strategy |
| `new-project` | **Canonical** — bootstrap new repo: stack, GitHub, scaffold, MORA, OAuth, mnjz.in DNS/VPS (Cursor + Telegram) |
| `init-project` | Alias for `new-project` |
| `pre-mvp-audit` | Pre-launch codebase audit tied to core user loop |
| `run-mora` | Bootstrap MORA on a new Mac or after pull |
| `refresh-mora` | Alias for `run-mora` |
| `caveman` | Communication intensity reference (Cursor enforces via rules + hooks) |

## Install (automatic)

From mora repo:

```bash
./run-mora.sh
```

This symlinks every skill here to **both**:

- `~/.cursor/skills/`
- `~/.claude/skills/`

Re-run after `git pull` on any Mac.

## Manual symlink (if needed)

```bash
MONO=~/Documents/work/monjizeen-dev
mkdir -p ~/.cursor/skills ~/.claude/skills
for skill in "$MONO"/shared-assets/skills/*/; do
  name=$(basename "$skill")
  [[ -f "$skill/SKILL.md" ]] || continue
  ln -sfn "$skill" ~/.cursor/skills/"$name"
  ln -sfn "$skill" ~/.claude/skills/"$name"
done
```

## Usage

Invoke with `/` in Cursor or Claude Code:

```
/start-work
/finish-work
/cleanup
/new-project
/init-project
/pre-mvp-audit
/run-mora
/cto
/ceo
```

Or trigger naturally: "start work on …", "finish work", "should we build this" → CEO review.

## File structure

```
skills/
├── start-work/SKILL.md
├── finish-work/SKILL.md
├── cleanup/SKILL.md
├── cto/SKILL.md
├── ceo/SKILL.md
├── new-project/SKILL.md
├── init-project/
│   ├── SKILL.md      # alias → new-project
│   └── reference.md
├── pre-mvp-audit/
│   ├── SKILL.md
│   └── CHECKLIST.md
├── run-mora/SKILL.md
├── refresh-mora/SKILL.md
├── caveman/SKILL.md
└── README.md
```

## init-project scripts

See `../scripts/init-project/` — Gate 0 of `/new-project` runs `bootstrap-mac.sh`; `run-mora.sh` links skills automatically.

## Caveman plugin

Do **not** install the marketplace `caveman@caveman` plugin — it duplicates org skills (`cavecrew`, `caveman-commit`, `compress`, etc.). Use the single `caveman` skill here; Cursor enforces intensity via MORA rules + hooks.

If already installed: `claude plugin uninstall caveman@caveman`

## Updating

Edit `SKILL.md` in this repo. Commit + push. Run `./run-mora.sh` on each Mac (or rely on symlinks — changes apply immediately).

## Troubleshooting

**Skill not appearing:**
- Verify symlink: `ls -l ~/.cursor/skills/{name}` and `ls -l ~/.claude/skills/{name}`
- Both should point to `shared-assets/skills/{name}`
- Re-run `./run-mora.sh`
- Restart Cursor or Claude Code

**Stale copy instead of symlink:**
- Remove the copy: `rm -rf ~/.claude/skills/{name}`
- Re-run `./run-mora.sh`
