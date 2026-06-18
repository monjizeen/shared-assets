---
name: finish-work
description: Finish the current task by running tests, committing, pushing, creating a PR, and monitoring until merge succeeds. Use when the user says "finish work", "ship it", "wrap up", "done with this", or invokes /finish-work.
---

## Finish Work

### When to use

* "finish work"
* "ship it"
* "wrap up"
* "done with this"
* "create a PR"
* Any time the user is done with the current task and wants to ship

---

## Steps

### 1. Run all required tests

Run the full test/lint suite before anything else:

```bash
composer check
npm run lint
```

- `composer check` runs Pint (formatting) + PHPStan (static analysis) + tests.
- `npm run lint` checks frontend code.

**If tests fail:** Fix the issues proactively. Re-run until all pass. Do not
proceed to commit until everything is green.

### 2. Check for uncommitted changes

Run `git status`. If there are uncommitted changes:

- Stage only the files you actually changed (never `git add -A` or `git add .`):
  ```bash
  git add path/to/file1 path/to/file2
  ```
- Commit with a short imperative message explaining *why*:
  ```bash
  git commit -m "message here"
  ```
- One commit per logical unit. If there are multiple logical changes, make
  multiple commits.
- Never commit `.env`, credentials, or secrets.

### 3. Push the branch

```bash
git push -u origin HEAD
```

### 4. Create a Pull Request

```bash
gh pr create --title "Short title under 70 chars" --body "$(cat <<'EOF'
## Summary
- bullet point describing what changed and why

## Test plan
- [ ] Tests pass (composer check)
- [ ] Lint passes (npm run lint)
- [ ] Additional manual verification if applicable

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Rules:
- PR title under 70 characters
- Summary explains *why*, not just *what*
- Test plan includes what was verified

### 5. Enable auto-merge

```bash
gh pr merge --auto
```

This will merge the PR automatically once all required checks pass.

### 6. Monitor CI

#### Estimate wait time from change size

Before the first poll, count the changed files in the PR to determine polling
intervals:

```bash
gh pr diff --name-only | wc -l
```

| Change size          | Initial wait | Subsequent polls |
|----------------------|-------------|------------------|
| Small (1–3 files)    | 60 s        | 30 s             |
| Medium (4–10 files)  | 90 s        | 45 s             |
| Large (11+ files)    | 120 s       | 60 s             |

#### Polling loop

1. Tell the user the estimated initial wait and say:
   **"Type `try now` if you'd like to skip the wait and check immediately."**
2. Wait the initial interval, then run `gh pr checks`.
3. If checks are still pending, tell the user you'll check again in N seconds
   and repeat the `try now` prompt. Wait the subsequent interval.
4. If the user responds with `try now` (or similar: "check now", "skip",
   "go"), skip the remaining wait and run `gh pr checks` immediately.
5. Repeat until checks resolve (pass or fail).

#### If checks fail

1. Read the failure output to understand what broke
2. Fix the issue locally
3. Run `composer check` and `npm run lint` again locally to verify
4. Commit the fix (new commit, never amend)
5. Push again: `git push`
6. Restart the polling loop (reset to initial wait for the new push)
7. Repeat up to **3 cycles**

If after 3 cycles checks still fail, stop and report the issue to the user
with the error details.

### 7. Wait for merge

Once checks pass and auto-merge completes:

```bash
gh pr view --json state --jq '.state'
```

If state is `MERGED`, proceed to cleanup.

### 8. Clean up local branch

```bash
git checkout main
git pull origin main
git fetch --prune
git branch -d {branch-name}
```

- Remote branch is auto-deleted by GitHub (repo setting enabled).
- Use `git branch -d` (safe delete). If it says "not fully merged" after a
  squash/rebase merge on GitHub, confirm with user before using `-D`.

### 9. Report to user

Tell the user:
- PR URL
- Merge status (merged successfully / failed with details)
- Local cleanup done
- Back on main, synced

---

## Rules

- **Never force-push.** If there's a conflict, rebase non-interactively or ask
  the user.
- **Never amend commits.** Always create new commits for fixes.
- **Never skip hooks** (`--no-verify`). Fix the root cause instead.
- **Stage files explicitly** — never `git add -A` or `git add .`.
- **Stop after 3 CI fix cycles** — don't loop forever.
