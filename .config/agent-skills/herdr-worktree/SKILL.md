---
name: herdr-worktree
description: Manage parallel development environments with Worktrunk and Herdr. Use when asked to create, open, switch, inspect, or remove a Git worktree; start Codex or Claude Code in a separate branch environment; or organize parallel agent work by repository, branch, Herdr workspace, and tab.
---

# Herdr Worktree

Use Worktrunk as the sole owner of Git worktrees. Do not use `herdr worktree create` or `herdr worktree remove`.

Organize the terminal hierarchy as follows:

- Herdr session: machine-wide persistent session
- Workspace: repository
- Tab: worktree or branch
- Pane: agent, shell, server, test, or editor

## Create a parallel agent environment

1. Verify that `git`, `wt`, `herdr`, and `jq` are available.
2. Verify that the current directory belongs to a Git repository.
3. Verify that the command runs inside Herdr using `HERDR_ENV=1`.
4. Determine the requested branch and optional base revision.
5. Determine the current agent kind:
   - Use `codex` when running from Codex.
   - Use `claude` when running from Claude Code.
6. Run:

   ```sh
   scripts/create-worktree-tab.sh <branch> <codex|claude> [base]
   ```

7. Report:
   - branch
   - worktree path
   - Herdr workspace ID
   - Herdr tab ID
   - Herdr pane ID
   - agent name
8. Do not modify files in the new worktree unless the user also requested implementation.

If the worktree or matching Herdr tab already exists, focus and reuse it instead of creating a duplicate.

If creation partially fails, preserve the worktree and tab, report the remaining resources, and do not automatically delete them.

## Remove a worktree environment

Treat removal as destructive.

1. Run removal from another worktree or tab. Never remove the worktree containing the current agent.
2. Inspect the target with:

   ```sh
   wt list --format=json
   git -C <worktree-path> status --short
   ```

3. Check for:
   - staged, modified, or untracked files
   - commits not integrated into the default branch
   - running processes in the associated Herdr tab
4. Report the exact branch, path, tab, changes, and processes that would be removed.
5. Obtain explicit user confirmation.
6. Close the associated Herdr tab.
7. Run:

   ```sh
   wt remove --foreground <branch>
   ```

8. Verify that the tab, worktree, and branch have been removed.

Never use `--force` unless the user explicitly requests it after seeing the risks. Never delete a branch or directory directly to bypass Worktrunk safeguards.

## Start a visible pane agent

Use a new pane in the current tab only for work that is safe to perform in the same worktree:

- research and code reading
- log or test monitoring
- reviews that do not edit files
- independent shell commands that do not mutate shared state

Run:

```sh
scripts/start-agent-pane.sh <codex|claude> <name> [right|down] [ratio] [prompt]
```

The default direction is `right` and the default ratio is `0.5`. The ratio is the source pane's retained share, so `0.8` creates a new pane occupying approximately 20 percent.

Treat the new process as a visible Herdr agent, even if the caller describes it as a subagent. Report its agent name and pane ID so it can be focused, inspected, prompted, or stopped through Herdr.

Do not start multiple file-writing agents in the same worktree. For implementation, formatting, dependency updates, migrations, or any other task that may modify files, create a separate worktree and tab instead.

Before starting a same-worktree pane agent that may write, explain the collision risk and require the user to choose either read-only operation or a separate worktree.

## Choose the isolation level

- Same tab and pane split: read-only investigation or process monitoring.
- New worktree and tab: any agent that may edit files or create commits.
- New workspace: a different repository or unrelated project context.

Prefer filesystem isolation over relying on prompts when two agents could write concurrently.

## Operational rules

- Preserve Worktrunk hooks; repository-specific setup and Docker cleanup may depend on them.
- Do not create worktrees under ad-hoc paths. Accept the path returned by Worktrunk.
- Do not edit the main worktree as part of creating a parallel environment.
- Use branch names as Herdr tab labels.
- Convert branch names into valid Herdr agent names.
- Prefer `herdr agent start` over typing an agent command into a pane.
- Use `herdr agent prompt` to submit an initial task after the agent is ready.
- Name visible agents by role or branch so the sidebar remains understandable.
- Keep security-sensitive Herdr remote and machine features unused.
