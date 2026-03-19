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
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --marker=' ✓' --pointer=' '"
    else
        set -gx FZF_DEFAULT_OPTS " \
            --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
            --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
            --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
            --marker=' ✓' --pointer=' '"
    end

    # Oh My Posh (re-init with new config)
    if type -q oh-my-posh
        oh-my-posh init fish --config "$HOME/.config/oh-my-posh/$THEME.omp.json" | source
    end
end
