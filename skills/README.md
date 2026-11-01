# monjizeen Skills (single source of truth)

All custom skills live here — versioned on GitHub. **Do not edit copies** under `~/.claude/skills/` or `~/.cursor/skills/`.

## Skills

| Skill | Purpose |
|-------|---------|
| `start-work` | Sync main (QUICK) or confirm branch (WORKTREE); challenge scope before coding |
| `finish-work` | Test, commit, push when done — no auto PR or merge |
| `cleanup` | Sync main, prune branches, clean local git state |
| `cto` | Review technical decisions, architecture, code quality |
| `ceo` | Review business decisions, unit economics, strategy |
| `client-ceo` | Coordinator rules for each client's Claude project; paste-in text in `client-ceo/PROJECT-INSTRUCTIONS.md`; status in `../clients/` |
| `new-project` | **Canonical** — bootstrap new repo: stack, GitHub, scaffold, repo list, OAuth, mnjz.in DNS/VPS |
| `init-project` | Alias for `new-project` |
| `pre-mvp-audit` | Pre-launch codebase audit tied to core user loop |
| `refresh` | Sync **active workspace** repo — pull, deps, migrate, restart dev server |

### Service skills

Our methods and standards for each service Monjizeen sells. Client context
plugs in through `client-context-brief`. Plan and status: [SERVICES.md](SERVICES.md).

| Skill | Purpose |
|-------|---------|
| `client-context-brief` | Build a client's kit at onboarding and turn it into a one-page brief per task |
| `social-media-graphic` | Social post, carousel, story and ad graphics, Arabic and English |

## Install

On a Mac, `scripts/init-project/bootstrap-mac.sh` links every skill here into
`~/.cursor/skills/` and `~/.claude/skills/`. Claude project threads read them
straight from this repo. (MORA's `run-mora.sh` used to do this; MORA was retired
on 2026-11-01. The repo list is now [`../docs/REPOS.md`](../docs/REPOS.md).)

## Manual symlink (if needed)

```bash
MONO=~/Documents/work/projects/monjizeen
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
/refresh
/new-project
/init-project
/pre-mvp-audit
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
├── refresh/SKILL.md
├── cto/SKILL.md
├── ceo/SKILL.md
├── client-ceo/
│   ├── SKILL.md
│   └── PROJECT-INSTRUCTIONS.md
├── new-project/SKILL.md
├── init-project/
│   ├── SKILL.md      # alias → new-project
│   └── reference.md
├── pre-mvp-audit/
│   ├── SKILL.md
│   └── CHECKLIST.md
└── README.md
```

## init-project scripts

See `../scripts/init-project/` — Gate 0 of `/new-project` runs `bootstrap-mac.sh`; it also links the skills.

## Updating

Edit `SKILL.md` in this repo. Commit + push. Symlinks pick up changes after `git pull`.

## Troubleshooting

**Skill not appearing:**
- Verify symlink: `ls -l ~/.cursor/skills/{name}` and `ls -l ~/.claude/skills/{name}`
- Both should point to `shared-assets/skills/{name}`
- Re-run `scripts/init-project/bootstrap-mac.sh`
- Restart Cursor or Claude Code

**Stale copy instead of symlink:**
- Remove the copy: `rm -rf ~/.claude/skills/{name}`
- Re-run `scripts/init-project/bootstrap-mac.sh`
