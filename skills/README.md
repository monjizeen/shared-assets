# Claude Code Skills

Custom skills for workflow automation. Copy or symlink to `~/.claude/skills/` for use across all projects.

## Skills Available

| Skill | Purpose |
|-------|---------|
| `start-work` | Create branch, sync main, prep workspace |
| `finish-work` | Test, commit, push, create PR, monitor merge |
| `cleanup` | Sync main, prune branches, clean local state |
| `cto` | Review technical decisions, architecture, code quality |
| `ceo` | Review business decisions, unit economics, strategy |
| `init-project` | Bootstrap new repo: GitHub, scaffold, MORA, Google OAuth, mnjz.in DNS/VPS |

## Setup

### Option 1: Copy (recommended for teams)

```bash
cp -r shared-assets/skills/* ~/.claude/skills/
# Cursor:
cp -r shared-assets/skills/* ~/.cursor/skills/
```

Skills become available immediately. Updates require re-copying.

### Option 2: Symlink (for development)

```bash
# From repo root
ln -s $(pwd)/shared-assets/skills/* ~/.claude/skills/
```

Skills pull latest from repo automatically. Good for iterating on skill definitions.

## Usage

Invoke skills with `/` command:

```
/start-work
/finish-work
/cleanup
/init-project
/cto
/ceo
```

Or trigger them naturally in conversation:
- "start work on user authentication"
- "finish work"
- "cleanup"
- "init project" or "set up a new project"
- "should we build this" → triggers CEO review

## File Structure

Each skill is a directory with `SKILL.md`:

```
skills/
├── start-work/
│   └── SKILL.md
├── finish-work/
│   └── SKILL.md
├── cleanup/
│   └── SKILL.md
├── cto/
│   └── SKILL.md
├── ceo/
│   └── SKILL.md
├── init-project/
│   ├── SKILL.md
│   └── reference.md
└── README.md (this file)
```

### init-project scripts

| Script | Purpose |
|--------|---------|
| `bootstrap-mac.sh` | New Mac setup: skill symlink, secrets from VPS, SSH config |
| `gate7.sh` | DNS + SSH deploy |
| `dns.sh` | Cloudflare A record |
| `remote-setup.sh` | VPS app setup (via SSH) |
| `nginx-vhost.sh` | Per-app nginx vhost |
| `env-production.sh` | Production `.env` merge |
| `verify.sh` | HTTPS + OAuth smoke test |

New Mac: `git clone shared-assets` → run `bootstrap-mac.sh` → `/init-project`.

## Updating Skills

Edit `SKILL.md` in the skill directory. If using symlink, changes take effect immediately. If using copy, re-run copy command.

## Troubleshooting

**Skill not appearing in Claude Code:**
- Verify `~/.claude/skills/{skill-name}/SKILL.md` exists
- Restart Claude Code
- Check Claude Code skill list: skills listed in UI under "Available"

**Symlink broken:**
- Verify symlink path: `ls -l ~/.claude/skills/`
- Recreate symlink if repo moved

**Name conflicts:**
- Custom skills override built-in skills with same name (rare)
- Rename custom skill if collision occurs
