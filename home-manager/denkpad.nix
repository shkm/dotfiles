{ inputs, pkgs, ... }: {
  imports = [ ./common.nix ./conf.d/firefox.nix ];

  # Denkpad is currently my only NixOS machine, and GUI apps
  # aren't too happy installed here on other OSes.
  home.packages = with pkgs; [
    spotify
    signal-desktop
    skypeforlinux
    spotify
    bitwarden
    nextcloud-client
    obsidian
    gnome.dconf-editor
    steam
  ];
}
