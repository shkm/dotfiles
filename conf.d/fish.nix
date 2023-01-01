{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      cat = "bat";
      dc = "docker compose";
      dka = "docker kill (docker ps -q)";
      ducks = "du -cksh * | sort -hr";
      g  = "git";
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
    '';
  };
}
