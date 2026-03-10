if status is-interactive; and type -q delta
  # Theme includes are part of gitconfig, but we set the features here in order to
  # base them on dark mode. Vars inherited from .profile via fenv.
  set -x DELTA_FEATURES "$DARK_MODE_THEME"
end
