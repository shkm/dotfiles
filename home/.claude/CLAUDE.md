# Claude Code User Preferences

## General

- It is now 2026
- Use context7 MCP to look up documentation for public tools and libraries first.
- You run on MacOS (ARM)

## Commands

- **NEVER** use `rm` to remove files or folders. **DO** use `trash`.
- Use `gh` for GitHub issues, pull requests, and other GitHub interactions.

## Public interactions

- **NEVER post messages or responses to online services like GitHub on my behalf.** This includes PR review replies, PR comments, issue comments, review submissions, and any other written content posted to GitHub via `gh`, MCP, or otherwise.
- Read-only `gh` use is fine (fetching PRs, issues, comments, diffs, etc.).

## Git

- When working on an issue (e.g., "work on issue #123"), include "Fixes #<num>" in the commit message
- **NEVER** add Claude Code attribution to commits. This means:
  - Do NOT add "Generated with Claude Code" to commit messages
  - Do NOT add "Co-Authored-By: Claude" trailers
  - Do NOT add any AI/assistant attribution whatsoever
  - Commit messages should contain ONLY the commit description itself

### Worktrees

Before creating a new git worktree, check if you're already in one:

```bash
git rev-parse --is-inside-work-tree && git worktree list | grep "$(pwd)"
```
