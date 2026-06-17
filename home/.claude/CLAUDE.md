# Claude Code User Preferences

## General

- It is now 2026
- Use context7 MCP to look up documentation for public tools and libraries first.
- You run on MacOS (ARM)
- Strive for "simple" implementations over complex ones. "Simple" means boring, easy to trace, not "clever". Push back with simpler ways of achieving things when you notice unneeded complexity.
- Work with minimum viable deliverables. This may mean splitting up a large feature into smaller features, ideally with each feature adding some small value.

## Commands

- **NEVER** use `rm` to remove files or folders. **DO** use `trash`.
- Use `gh` for GitHub issues, pull requests, and other GitHub interactions.

### mise (tool versions)

My tools (Ruby, Node, etc.) are managed by mise. Claude Code's tool shell
captures its PATH once at GUI launch (in `$HOME`), so it often points at the
wrong, global tool version — not the project's. To get the project-correct
version, run mise-managed tooling through mise:

- Prefix commands with `mise exec --` (alias `mise x --`), e.g.
  `mise exec -- bundle exec rspec`, `mise exec -- ruby script.rb`.
- **Do NOT** pin a version (`mise exec ruby@3.3.10 -- …`). Let mise resolve it
  from the current directory's `.tool-versions`/config so it stays correct
  across projects.
- If a command fails with missing gems / wrong language version, it's almost
  certainly this — re-run it via `mise exec --`.
- This includes git hooks: if `git commit`/`git push` fails because a hook
  (e.g. lefthook running standardrb/brakeman) can't find gems, run the git
  command itself through mise (`mise exec -- git commit …`) so the hook's
  subprocesses inherit the right version. Prefer this over `--no-verify`.

## Public interactions

- **NEVER post messages or responses to online services like GitHub on my behalf.** This includes PR review replies, PR comments, issue comments, review submissions, and any other written content posted to GitHub via `gh`, MCP, or otherwise.
- Read-only `gh` use is fine (fetching PRs, issues, comments, diffs, etc.).
- If you do want to post something, ask explicit permission.

## Git

- When working on an issue (e.g., "work on issue #123"), include "Fixes #<num>" in the commit message
- **NEVER** add Claude Code attribution to commits.

### Commit message conventions

If there are no other specific commit conventions, use these:

- Separate subject from body with a blank line
- Limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with a period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Use the body to explain what and why vs. how

### Worktrees

Before creating a new git worktree, check if you're already in one:

```bash
git rev-parse --is-inside-work-tree && git worktree list | grep "$(pwd)"
```
