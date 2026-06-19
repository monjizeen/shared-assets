---
name: finish-work
description: Wrap up a task — run checks, commit, push when done. No automatic PRs or merges. Use when the user says "finish work", "ship it", "wrap up", "done with this", or invokes /finish-work.
---

# Finish Work

Org-wide skill for monjizeen-dev repos. Repo-local overrides win when present.

## Two modes only

| Mode | Detect | Finish behavior |
|------|--------|-----------------|
| **QUICK** | `.git` is a directory | Commit on `main`; optional push when task done |
| **WORKTREE** | `.git` is a file | Commit on branch; push for review; Omar merges manually |

```bash
if [ -f .git ]; then echo WORKTREE; else echo QUICK; fi
```

## When to invoke

- The user says "finish work", "ship it", "wrap up", "done with this"
- After completing a coding task that changed the repo
- **Stop hook fired** with uncommitted changes — commit now (do not push unless task is done)

**Never** create PRs automatically. **Never** auto-merge into `main`.

---

## During work (commit frequently)

After meaningful edits, commit without waiting for task end:

- Stage only files you actually changed (never `git add -A` or `git add .`):
  ```bash
  git add path/to/file1 path/to/file2
  ```
- Commit with a short imperative message explaining *why*:
  ```bash
  git commit -m "message here"
  ```
- One commit per logical unit. Never commit `.env`, credentials, or secrets.
- **Do not push** mid-task unless Omar asks for backup.

---

## Task complete (full finish-work)

Run when the task is done or Omar says to wrap up.

### 1. Run all required tests

Run only what the repo provides:

```bash
# PHP / Laravel repos
test -f composer.json && composer check

# Frontend / Node repos
test -f package.json && npm run lint
```

- `composer check` (when present): formatting + static analysis + tests.
- `npm run lint` (when present): frontend lint.

**If tests fail:** Fix the issues. Re-run until all pass. Do not proceed until green.

### 2. Commit remaining changes

Run `git status`. If there are uncommitted changes, commit using the rules above.

### 3. Push (task complete or backup only)

Push when the task is complete, or when Omar explicitly asks for backup:

```bash
git push -u origin HEAD
```

**QUICK mode:** Push to `main` only if Omar wants it now (end of task or backup). Otherwise report commits are local.

**WORKTREE mode:** Push the branch so Omar can review. Do not merge.

### 4. Report

**QUICK mode:**
> Task done. Commits on `main`. [Pushed / not pushed — say which.] `main` should stay deployable.

**WORKTREE mode:**
> Branch `{branch}` pushed and ready for your review. Merge into `main` when satisfied, then delete the branch and close this worktree.

If Omar later says "merge it", help with the local merge steps — but only when explicitly asked. Never auto-merge.

---

## Rules

- **Never force-push.** If conflict, rebase non-interactively or ask Omar.
- **Never amend commits** unless Omar explicitly requests it and the commit was not pushed.
- **Never skip hooks** (`--no-verify`). Fix the root cause.
- **Stage files explicitly** — never `git add -A` or `git add .`.
- **Never create PRs** unless Omar explicitly asks.
- **Never auto-merge** into `main`.
- **`main` must always stay stable and deployable.**
