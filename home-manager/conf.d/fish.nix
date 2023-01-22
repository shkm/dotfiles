{ config, pkgs, lib, ... }: {
  programs.fish = {
    enable = true;
    plugins = [{
      name = "foreign-env";
      src = pkgs.fishPlugins.foreign-env;
    }];
    shellAbbrs = {
      cat = "bat";
      dc = "docker compose";
      dka = "docker kill (docker ps -q)";
      ducks = "du -cksh * | sort -hr";
      g = "git";
      gcd = "cd (git rev-parse --show-toplevel)";
      ll = "exa -lga --group-directories-first";
      ls = "ll";
      sshkey = "clip $HOME/.ssh/id_ed25519.pub";
      rm = "trash";
      v = "nvim";
      "v." = "nvim .";
    };
    shellInit = ''
      # Workaround issue with editor not getting set right
      set -gx EDITOR nvim
      set -gx SUDOEDITOR nvim

      # https://github.com/NixOS/nix/issues/2033
      set --prepend fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d
      fenv source ${./export-nix-path}

      # shh
      set -U fish_greeting

      # asdf
      source ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
      source ${pkgs.asdf-vm}/share/fish/vendor_completions.d/asdf.fish
    '';
  };
}
