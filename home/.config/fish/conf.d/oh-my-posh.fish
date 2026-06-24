if status is-interactive; and type -q oh-my-posh
    # Vars inherited from .profile via fenv.
    oh-my-posh init fish --config "$HOME/.config/themes/active/omp/$VARIANT.omp.json" | source
end
