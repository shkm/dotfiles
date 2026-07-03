if command -q gitui
    function gitui --wraps=gitui
        # Live-check appearance (not stale from shell init)
        set -l theme (theme-env | string match -r '^export THEME=(.+)')[2]
        if test -f "$HOME/.config/gitui/$theme.ron"
            command gitui -t "$theme.ron" $argv
        else
            command gitui $argv
        end
    end
end
