{ inputs, pkgs, ... }: {
  imports = [ ./common.nix ./conf.d/firefox.nix ];
  home = {
    username = "jamie";
    homeDirectory = "/home/jamie";

    # Denkpad is currently my only NixOS machine, and GUI apps
    # aren't too happy installed here on other OSes.
    packages = with pkgs; [
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
  };
}
