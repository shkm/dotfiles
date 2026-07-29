# Sourced for every zsh (all modes), unlike ~/.zprofile which is login-only.
. "$HOME/.config/shell/env"

# Interactive shells get the full mise integration (cd-hook, wrapper, cmd-not-
# found); scripts only need PATH resolved for the cwd — one subprocess, not two.
if command -v mise >/dev/null 2>&1; then
  if [[ -o interactive ]]; then
    eval "$(mise activate zsh)"
  else
    eval "$(mise hook-env -s zsh)"
  fi
fi
