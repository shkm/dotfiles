complete -c theme-switch -f -a "(ls ~/.config/themes 2>/dev/null | string match -v active)" -d "Theme"
