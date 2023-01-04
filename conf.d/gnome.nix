{ lib, ... }:
let
  defaultFont = "Inter Regular 11";
  monospaceFont = "JetBrainsMonoNL Nerd Font Mono 10";
in
{
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "gnomespotifylabel@mheine.github.com"
        "trayIconsReloaded@selfmade.pl"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "no_activities@yaya.cout"
        "sound-output-device-chooser@kgshank.net"
        "hide-activities-button@gnome-shell-extensions.bookmarkd.xyz"
        "tiling-assistant@leleat-on-github"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
      mouse-button-modifier = ["<Super>"];
      titlebar-font = defaultFont;
      audible-bell = false;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-input-source = [];
      switch-input-source-backward = [];
      close = ["<Super>w"];
      maximize = ["<Super>k"];
      minimize = ["<Super>j"];
      toggle-tiled-left = ["<Super>h"];
      toggle-tiled-right = ["<Super>l"];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-name = defaultFont;
      document-font-name = defaultFont;
      monospace-font-name = monospaceFont;
      gtk-enable-primary-paste = false; # Disable middle-click paste
      gtk-key-theme = "Emacs";
      clock-show-weekday = true;
      show-battery-percentage = true;
      enable-hot-corners = false;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape" "compose:rctrl"];
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      accelprofile = "flat";
      speed = 0.0;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      tap-to-click = true;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 150;
      repeat-interval = lib.hm.gvariant.mkUint32 10;
    };
    "org/gnome/shell/extensions/spotifylabel" = {
      left-padding = 0;
      right-padding = 0;
      max-string-length = 40;
      friendly-greeting = false;
      artist-first = true;
      extension-place = "left";
      extension-index = 0;
      toggle-window = true;
    };
  };
}
