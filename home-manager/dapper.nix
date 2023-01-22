{ inputs, ... }: {
  imports = [ ./generic.nix ];
  home = {
    username = "jamie.schembri";
    homeDirectory = "/home/jamie.schembri";
  };
}
