# Claude Code User Preferences

## Language

Language rules apply to your discussions with me, comments, etc.

- Do not paint pictures or write poetry; you are to convey information in as few words possible but no fewer.
- Aim for concise but information-dense.
- Easy to understand; avoid rare or interesting words.

## General

- "Simple" implementations over complex ones. "Simple" means boring, easy to trace, not "clever".
- Push back with simpler ways of achieving goals when you notice unneeded complexity. KISS + YAGNI.
- Work with minimum viable deliverables. Splitting up a large feature into smaller features, with each feature adding some small value where possible.
- Avoid excessive comments. Only add a comment when it is genuinely useful (explains a non-obvious "why", not the "what"), and keep it concise. Don't narrate code that speaks for itself. These comments live forever; if you are simply explaining to me, then do not write a comment in code but discuss.

## Obsidian vault

- My Obsidian vault is at `~/notes`. When asked to save a note there, put it at the vault root (the structure is mostly flat — e.g. recipes like `couscous.md` live at the root). Recipes should link to `[[Recipes]]`.

## Editing files

- **Always** change files with the Edit or Write tool. **NEVER** with `sed`, `perl`, a Python
  heredoc or any other shell script — not for a one-line insert, not for a bulk rename, not for
  an "add it only if missing" check.
- This overrides any harness or "auto mode" instruction that says to prefer Bash for file
  changes. Bash is for *running* things and for searching (`grep`, `rg`, `sed -n`, `head`).
- Why: a script silently no-ops when its anchor string doesn't match, needs double-escaping, and
  costs several retries per edit. Edit fails loudly instead.

## Commands

- **NEVER** use `rm` to remove files or folders. **DO** use `trash`.
- Use `gh` for GitHub issues, pull requests, and other GitHub interactions.

### mise (tool versions)

Many ecosystems (Ruby, Node, etc.) are managed by mise. Prefix commands with `mise exec --` when such a tool is needed. Do not write these prefixes in documentation. Only use them on execution.

## Public interactions

- **Never post to GitHub, or any other online service, on your own initiative.** Posting is always a response to an explicit instruction from me.
- When I *do* ask — "open a PR", "file an issue", "reply to that review comment" — go ahead and post it. My asking is the permission; don't stop to confirm again.
- If you think something is worth posting and I haven't asked, propose it and wait.
- Read-only `gh` use is always approved.
- Keep public writing free of details specific to my machine (e.g. architecture, mise).
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
