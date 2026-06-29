# Re-check OS appearance before each prompt and update tools when it changes.
if not status is-interactive
    return
end

function __theme_apply
    set -l theme_dir $HOME/.config/themes/$THEME

    # Delta
    if type -q delta
        set -gx DELTA_FEATURES "$THEME"
    end

    # FZF
    if test -f $theme_dir/fzf.opts
        set -gx FZF_DEFAULT_OPTS (cat $theme_dir/fzf.opts)
    end

    # Oh My Posh (re-init with new config)
    if type -q oh-my-posh
        oh-my-posh init fish --config "$theme_dir/omp.omp.json" | source
    end

    # Fish prompt colors. `theme save` (vs `choose`) writes universal vars
    # so other running fish shells pick up the change automatically.
    # Pipe `y` to bypass the interactive overwrite prompt.
    if test -f ~/.config/fish/themes/$FISH_THEME.theme
        echo y | fish_config theme save "$FISH_THEME" >/dev/null
        set -U __fish_active_theme "$FISH_THEME"
    end
end

function __theme_sync --on-event fish_prompt
    set -l prev $THEME
    eval (theme-env)
    # Apply when dark/light just toggled, *or* when the universal fish
    # colours don't yet match the current theme (the first prompt of a
    # fresh shell after a theme-switch — $THEME is already correct from
    # .profile, so a prev/THEME comparison alone would miss it).
    if test "$prev" != "$THEME"
        __theme_apply
    else if test "$__fish_active_theme" != "$FISH_THEME"
        __theme_apply
    end
end
