#!/usr/bin/env bash
#
# discover dconf changes with:
#   dconf watch /

function describe() {
  echo "  > $1"
}

describe "Light mode"
dconf write /org/gnome/desktop/interface/color-scheme "'default'"

describe "Papirus icons"
dconf write /org/gnome/desktop/interfaces/icon-theme "'Papirus'"

describe "Papirus icons"
dconf write /org/gnome/desktop/interface/cursor-size 48

describe "Monospace font"
dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrainsMonoNL Nerd Font 10'"

describe "Use Emacs input"
dconf write /org/gnome/desktop/interface/gtk-key-theme "'Emacs'"

describe "Disable middle-click paste"
dconf write /org/gnome/desktop/interface/gtk-enable-primary-paste false

describe "Key repeat delay"
dconf write /org/gnome/desktop/peripherals/keyboard/delay "uint32 150"

describe "Key repeat interval"
dconf write /org/gnome/desktop/peripherals/keyboard/repeat-interval "uint32 10"

describe "Show weekday on top bar clock"
dconf write /org/gnome/desktop/interface/clock-show-weekday true

describe "Show battery % in top bar"
dconf write /org/gnome/desktop/interface/show-battery-percentage true

describe "Terminal bell"
dconf write /org/gnome/desktop/wm/preferences/audible-bell false

describe "Show min/max/close buttons on windows"
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"

describe "Resize windows with right-click + drag"
dconf write /org/gnome/desktop/wm/preferences/resize-with-right-button true
describe "Disable hot corners"
dconf write /org/gnome/desktop/interface/enable-hot-corners false

describe "Disable 'natural scroll'"
dconf write /org/gnome/desktop/peripherals/mouse/natural-scroll false
dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll false

describe "Flatten mouse speed"
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"
dconf write /org/gnome/desktop/peripherals/mouse/speed "0.0"

describe "Touchpad tap to click"
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true

describe "Make caps additional escape"
describe "Make compose right control"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape', 'compose:rctrl']"

# Keyboard mappings

describe "Drop input source mappings"
dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-input-source-backward "@as []"

describe "Close windows with Super+w"
dconf write /org/gnome/desktop/wm/keybindings/close "['<Super>w']"

describe "Maximise windows with Super+k"
dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>k']"

describe "Maximise windows with Super+j"
dconf write /org/gnome/desktop/wm/keybindings/minimize "['<Super>j']"

describe "Super+h / Super+l for tile left / right"
dconf write /org/gnome/mutter/keybindings/toggle-tiled-left "['<Super>h']"
dconf write /org/gnome/mutter/keybindings/toggle-tiled-right "['<Super>l']"


# Tilix
TILIX_PROFILE=$(gsettings get com.gexperts.Tilix.ProfilesList default | sed s/\'//g)

function tilixMap() {
  local key="$1"
  local value="$2"

  gsettings set com.gexperts.Tilix.Keybindings "$key" "$value"
}

function setTilixProfileKey() {
  local key="$1"
  local value="$2"

  gsettings set "com.gexperts.Tilix.Profile:/com/gexperts/Tilix/profiles/$TILIX_PROFILE/" "$key" "$value"
}

describe "Tilix: System dark/light mode"
gsettings set com.gexperts.Tilix.Settings theme-variant "'system'"

describe "Tilix: Window style"
gsettings set com.gexperts.Tilix.Settings window-style "'disable-csd-hide-toolbar'"

describe "Tilix: Title style"
gsettings set com.gexperts.Tilix.Settings terminal-title-style "'small'"

describe "Tilix: Use real tabs"
gsettings set com.gexperts.Tilix.Settings use-tabs true


describe "Tilix: Preferences in ctrl+comma"
tilixMap "app-preferences" "'<Primary>comma'"

describe "Tilix: Ctrl+Shift + | and - to create splits"
tilixMap "session-add-down" "'<Primary>underscore'"
tilixMap "session-add-right" "'<Primary>bar'"

describe "Tilix: Ctrl+Shift+hjlk split navigation"
tilixMap "session-switch-to-terminal-left" "'<Primary><Shift>h'"
tilixMap "session-switch-to-terminal-down" "'<Primary><Shift>j'"
tilixMap "session-switch-to-terminal-up" "'<Primary><Shift>k'"
tilixMap "session-switch-to-terminal-right" "'<Primary><Shift>l'"

describe "Tilix: Ctrl+Shift+w to close tab"
tilixMap "terminal-close" "'disabled'"
tilixMap "session-close" "'<Primary><Shift>w'"

describe "Tilix: Ctrl+Tab / Ctrl+Shift+Tab to navigate tabs"
tilixMap "session-switch-to-next-terminal" "'disabled'"
tilixMap "session-switch-to-previous-terminal" "'disabled'"
tilixMap "win-switch-to-next-session" "'<Primary>Tab'"
tilixMap "win-switch-to-previous-session" "'<Primary><Shift>Tab'"

# Profile stuff

describe "Tilix: Disable terminal bell"
setTilixProfileKey "terminal-bell" "'none'"

describe "Tilix: Disable scrollbar"
setTilixProfileKey "show-scrollbar" "false"

describe "Tilix: Colours for Catppuccin-Latte"
setTilixProfileKey "background-color" "'#EFF1F5'"
setTilixProfileKey "foreground-color" "'#4C4F69'"
setTilixProfileKey "badge-color" "'#ACB0BE'"
setTilixProfileKey "bold-color" "'#ACB0BE'"
setTilixProfileKey "cursor-background-color" "'#DC8A78'"
setTilixProfileKey "cursor-foreground-color" "'#EFF1F5'"
setTilixProfileKey "highlight-background-color" "'#DC8A78'"
setTilixProfileKey "highlight-foreground-color" "'#EFF1F5'"
setTilixProfileKey "palette" "['#5C5F77', '#D20F39', '#40A02B', '#DF8E1D', '#1E66F5', '#EA76CB', '#179299', '#ACB0BE', '#6C6F85', '#D20F39', '#40A02B', '#DF8E1D', '#1E66F5', '#EA76CB', '#179299', '#BCC0CC' ]"
setTilixProfileKey "cursor-colors-set" "true"
setTilixProfileKey "highlight-colors-set" "true"
setTilixProfileKey "use-theme-colors" "false"
