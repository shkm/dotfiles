# Re-check OS appearance before each prompt and update tools when it changes.
if not status is-interactive
    return
end

function __theme_sync --on-event fish_prompt
    set -l prev $THEME
    eval (theme-env)
    test "$prev" = "$THEME"; and return

    set -l active $HOME/.config/themes/active

    # Delta
    if type -q delta
        set -gx DELTA_FEATURES "$THEME"
    end

    # FZF
    if test -f $active/fzf/$VARIANT.opts
        set -gx FZF_DEFAULT_OPTS (cat $active/fzf/$VARIANT.opts)
    end

    # Oh My Posh (re-init with new config)
    if type -q oh-my-posh
        oh-my-posh init fish --config "$active/omp/$VARIANT.omp.json" | source
    end

    # Fish prompt colors. `theme save` (vs `choose`) writes universal vars
    # so other running fish shells pick up the change automatically.
    # Pipe `y` to bypass the interactive overwrite prompt.
    if test -f ~/.config/fish/themes/$FISH_THEME.theme
        echo y | fish_config theme save "$FISH_THEME" >/dev/null
    end
end
