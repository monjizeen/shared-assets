---
name: start-work
description: Begin a new task by syncing main, creating a properly named branch, and preparing the workspace. Use when the user says "start work", "new task", "begin working on", or invokes /start-work.
---

## Start Work

### When to use

* "start work on …"
* "new task: …"
* "begin working on …"
* Any time you are about to begin a new feature, fix, refactor, or chore

---

## Required Inputs (ask if missing)

* **Task description**: What the user wants to accomplish (used to name the branch)

---

## Steps

### 1. Check for open PRs

Run `gh pr list` to see existing open PRs. If there is an open PR for a
different scope of work, **flag it to the user** — that PR should be merged or
closed before mixing new work on the same base.

### 2. Sync main

```bash
git checkout main
git pull origin main
```

If pull fails due to a deleted upstream branch or stale refs:
```bash
git fetch --prune
git checkout main
git pull origin main
```

### 3. Determine branch prefix

Based on the task description, choose the correct prefix:

| Type | Prefix |
|------|--------|
| New feature | `feat/` |
| Bug fix | `fix/` |
| Refactor | `refactor/` |
| Maintenance / config / docs | `chore/` |

### 4. Create the branch

Generate a short kebab-case description (2-4 words max) from the task.

```bash
git checkout -b {prefix}{short-description}
```

Examples:
- "fix the login page error" → `fix/login-page-error`
- "add user roles management" → `feat/user-roles-management`
- "clean up unused services" → `refactor/unused-services`

### 5. Confirm ready

Tell the user:
- Branch name created
- Current state is clean and synced with main
- Ready to begin work

---

## Rules

- **Never commit directly to main.** Always create a branch first.
- **One branch = one logical change.** If the task reveals a separate fix, flag
  it — don't mix it in.
- Branch names are lowercase kebab-case, short, and descriptive.
