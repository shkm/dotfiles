if status is-interactive; and type -q oh-my-posh
    # One shared config; the active palette is selected by $THEME at render
    # time (palettes.template), so dark/light toggles recolour without re-init.
    oh-my-posh init fish --config "$HOME/.config/themes/omp.omp.json" | source
end
