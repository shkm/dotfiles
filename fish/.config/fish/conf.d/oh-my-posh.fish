if status is-interactive; and type -q oh-my-posh
    set omp_theme "catppuccin_mocha"

    if test "$DARK_MODE" = "0"
      set omp_theme "catppuccin_latte"
    end

    oh-my-posh init fish --config "$HOME/.config/oh-my-posh/$omp_theme.omp.json" | source
  end
