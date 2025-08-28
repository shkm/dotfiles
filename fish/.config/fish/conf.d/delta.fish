if status is-interactive; and type -q delta
  # Theme includes are part of gitconfig, but we set the features here in order to
  # base them on dark mode.
  if test "$DARK_MODE" = "0"
    set -x DELTA_FEATURES "catppuccin-latte"
  else
    set -x DELTA_FEATURES "catppuccin-mocha"
  end
end
