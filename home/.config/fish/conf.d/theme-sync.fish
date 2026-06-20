# Re-check OS appearance before each prompt and update tools when it changes.
if not status is-interactive
    return
end

function __theme_sync --on-event fish_prompt
    set -l prev $THEME
    eval (theme-env)
    test "$prev" = "$THEME"; and return

    # Delta
    if type -q delta
        set -gx DELTA_FEATURES "$THEME"
    end

    # FZF
    if test "$DARK_MODE" -eq 1
        set -gx FZF_DEFAULT_OPTS " \
            --color=bg+:#1c212b,bg:#0b0e14,spinner:#e6b450,hl:#f07178 \
            --color=fg:#bfbdb6,header:#f07178,info:#d2a6ff,pointer:#e6b450 \
            --color=marker:#e6b450,fg+:#bfbdb6,prompt:#d2a6ff,hl+:#f07178 \
            --marker=' ✓' --pointer=' '"
    else
        set -gx FZF_DEFAULT_OPTS " \
            --color=bg+:#e1e2e3,bg:#f8f9fa,spinner:#ffaa33,hl:#f07171 \
            --color=fg:#5c6166,header:#f07171,info:#a37acc,pointer:#ffaa33 \
            --color=marker:#ffaa33,fg+:#5c6166,prompt:#a37acc,hl+:#f07171 \
            --marker=' ✓' --pointer=' '"
    end

    # Oh My Posh (re-init with new config)
    if type -q oh-my-posh
        oh-my-posh init fish --config "$HOME/.config/oh-my-posh/$THEME.omp.json" | source
    end
end
