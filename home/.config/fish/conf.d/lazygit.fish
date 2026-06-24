if command -q lazygit
    function lazygit --wraps=lazygit
        # Live-check appearance (not stale from shell init)
        set -l variant (theme-env | string match -r '^export VARIANT=(.+)')[2]
        set -lx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.config/themes/active/lazygit/$variant.yml"
        command lazygit $argv
    end
end
