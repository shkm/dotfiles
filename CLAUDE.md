# Dotfiles Project Notes

## Version control

This repo is colocated jj + git. Use `jj` for all version control; reach for `git` only when jj has no equivalent.

- Commit with `jj commit -m`. There is no staging area; the working copy is the commit.
- Split a working copy into several commits with `jj split`.
- Push with `jj tug && jj git push`. `tug` moves `main` onto the last finished commit; `split` and `squash` leave it behind, so always run it first.
- Inspect with `jj log`, `jj show <rev>`, `jj diff`. Commits are named by change ID (e.g. `xuzolptm`), not hash.
- Commit subjects use the existing `[scope] Summary` style (e.g. `[nvim] ...`, `[dotfiles] ...`, `[claude] ...`); follow it without re-checking history unless asked for a different style.
