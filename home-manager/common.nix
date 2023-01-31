# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    sessionPath = [ "$HOME/bin" "$HOME/scripts" ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
    file = { ".asdfrc" = { source = ./conf.d/asdf/asdfrc; }; };
    file = { scripts = { source = ./conf.d/scripts; }; };

    packages = with pkgs; [
      nixfmt
      ripgrep
      exa
      fd
      httpie
      html-tidy
      procs
      asdf-vm
      tig
      wget
      ruby
      go
      glow
      lefthook

      # LSPs
      gopls

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  services = {
    espanso = {
      enable = true;
      settings = {
        matches = [
          {
            trigger = "rials";
            replace = "rails";
            word = true;
            propagate_case = true;
          }
        ];
      };
    };
  };


  xdg.configFile = {
    ideavim = {
      source = ./conf.d/ideavim/ideavimrc;
      target = "ideavim/ideavimrc";
    };
    tig = {
      source = ./conf.d/tig/config;
      target = "tig/config";
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Inter Regular 11";
      package = pkgs.inter;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zoxide.enable = true;
    tealdeer.enable = true;
    gh.enable = true;
    jq.enable = true;
    starship.enable = true;
    home-manager.enable = true;
    bat = {
      enable = true;
      config = { theme = "Dracula"; };
    };
    fzf = {
      enable = true;
      colors = {
        fg = "#f8f8f2";
        "fg+" = "#f8f8f2";
        bg = "#282a36";
        "bg+" = "#44475a";
        hl = "#bd93f9";
        "hl+" = "#bd93f9";
        info = "#ffb86c";
        prompt = "#50fa7b";
        pointer = "#ff79c6";
        marker = "#ff79c6";
        spinner = "#ffb86c";
        header = "#6272a4";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";

  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./conf.d/nvim.nix
    ./conf.d/fish.nix
    ./conf.d/git.nix
    ./conf.d/gnome.nix
    ./conf.d/terminator.nix
  ];

}
