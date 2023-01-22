{ inputs, ... }: {
  imports = [ ./common.nix ];
  targets.genericLinux.enable = true;
}
