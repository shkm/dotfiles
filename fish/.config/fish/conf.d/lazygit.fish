if command -q lazygit
    function lazygit --wraps=lazygit
        # Live-check appearance (not stale from shell init)
        set -l theme (theme-env | string match -r 'DARK_MODE_THEME=(.+)')[2]
        set -lx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/$theme.yml"
        command lazygit $argv
    end
end
