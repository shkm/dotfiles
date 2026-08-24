# Claude Code User Preferences

## General

- It is now 2026
- Use context7 MCP to look up documentation for public tools and libraries first.
- You run on MacOS (ARM)
- Strive for "simple" implementations over complex ones. "Simple" means boring, easy to trace, not "clever". Push back with simpler ways of achieving things when you notice unneeded complexity. KISS + YAGNI.
- Work with minimum viable deliverables. This may mean splitting up a large feature into smaller features, ideally with each feature adding some small value.
- Avoid excessive comments. Only add a comment when it is genuinely useful (explains a non-obvious "why", not the "what"), and keep it concise. Don't narrate code that speaks for itself.

## Obsidian vault

- My Obsidian vault is at `~/notes`. When asked to save a note there, put it at the vault root (the structure is mostly flat — e.g. recipes like `couscous.md` live at the root). Recipes should link to `[[Recipes]]`.

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

- **Never post to GitHub, or any other online service, on your own initiative.** Posting is always a response to an explicit instruction from me, never something you decide is a good idea.
- When I *do* ask — "open a PR", "file an issue", "reply to that review comment" — go ahead and post it. My asking is the permission; don't stop to confirm again.
- The instruction covers what I asked for and nothing more. Opening a PR isn't licence to comment on it; filing an issue isn't licence to close another.
- If you think something is worth posting and I haven't asked, propose it and wait.
- Read-only `gh` use is always fine (fetching PRs, issues, comments, diffs, etc.).
- Keep public writing free of details specific to my machine (e.g. ARM, mise).
- If there is a template for creating something (e.g. PR, issue) then use that template.

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
