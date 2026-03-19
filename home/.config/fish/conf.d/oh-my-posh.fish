if status is-interactive; and type -q oh-my-posh
    # Vars inherited from .profile via fenv.
    oh-my-posh init fish --config "$HOME/.config/oh-my-posh/$THEME.omp.json" | source
  end
