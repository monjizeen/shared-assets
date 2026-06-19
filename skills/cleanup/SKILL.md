---
name: cleanup
description: Clean up local git state by switching to main, pulling latest, pruning remote-tracking branches, and deleting local branches whose remote has been deleted. Use when the user says "cleanup", "clean up branches", "sync main", or invokes /cleanup.
---

## Cleanup

### When to use

* "cleanup"
* "clean up branches"
* "sync main"
* "prune branches"
* Any time the user wants to reset local git state back to a clean main

---

## Steps

### 1. Check for uncommitted changes

Run `git status`. If there are uncommitted changes or staged files:

- **Warn the user** and list the dirty files.
- Ask whether to stash, discard, or abort before proceeding.
- **Do not continue** until the working tree is clean or the user has explicitly
  chosen what to do with the changes.

### 2. Switch to main

```bash
git checkout main
```

If the checkout fails (e.g. detached HEAD, merge conflict), diagnose and report
to the user before continuing.

### 3. Pull latest

```bash
git pull origin main
```

Ensure `origin/main` is current before judging whether branch work landed on main.

### 4. Prune remote-tracking branches

```bash
git fetch --prune
```

This removes local remote-tracking refs for branches that no longer exist on the
remote.

### 5. Delete stale local branches

Collect candidates:

```bash
git branch -vv | grep ': gone]'
```

Also consider local branches fully merged into `main` (optional, same repo may use `cleanup-merged-branches.sh` for interactive merged cleanup):

```bash
git branch --merged main | awk '!/^\*/ && !/main$/'
```

For each candidate branch (skip `main`):

1. **Try safe delete:** `git branch -d {branch}`
2. **If `-d` fails** (common after squash/rebase merges on GitHub), check whether the branch work is already on remote `main` before keeping it:

```bash
# Tip is in main history (regular merge / fast-forward)
git merge-base --is-ancestor {branch} origin/main

# No diff vs main (squash merge: tip not in history, changes are)
git diff --quiet origin/main...{branch}
```

If **either** check succeeds, the branch is safe to remove locally — **force delete without asking:**

```bash
git branch -D {branch}
```

If **both** checks fail, the branch still has commits or changes not on `origin/main`. **Do not** `-D`. Report branch name and suggest the user verify or push/PR before deleting.

#### Worktree-attached branches

If `git branch -vv` shows `+` or `git worktree list` ties a branch to a path:

1. `git worktree remove {path}` (or `git worktree remove --force {path}` if dirty and user already chose cleanup)
2. `git worktree prune`
3. Then run the ancestor/diff checks and `-D` as above

Do not leave orphaned worktrees for branches you delete.

### 6. Report to user

Tell the user:

- Now on `main`, synced with origin
- Which branches were deleted (`-d` vs `-D`, and why: gone upstream, merged, or on `origin/main`)
- Which branches were kept because they still differ from `origin/main`
- Any worktrees removed

---

## Rules

- **Never delete branches without checking for uncommitted work first.**
- **Force-delete (`-D`) is allowed without extra confirmation** when `merge-base --is-ancestor` or `git diff --quiet origin/main...branch` proves the work is on remote `main`.
- **Never `-D` without those checks** when the branch still has unique commits or diffs vs `origin/main`.
- **Never discard uncommitted changes silently.**
- **Keep it idempotent** — running cleanup twice in a row should be safe.
