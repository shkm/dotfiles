{ lib, ... }:
{
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "sp-tray@sp-tray.esenliyim.github.com"
        "trayIconsReloaded@selfmade.pl"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "no_activities@yaya.cout"
        "sound-output-device-chooser@kgshank.net"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
      mouse-button-modifier = ["<Super>"];
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
      monospace-font-name = "JetBrainsMonoNL Nerd Font Mono 10";
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
    "org/gnome/shell/extensions/sp-tray" = {
      display-format = "{artist} - {track}";
      podcast-format = "{album} - {track}";
      position = 0;
      logo-position = 0;
      paused = "⏸";
      stopped = "⏹";
    };
  };
}
