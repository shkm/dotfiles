{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ../common.nix ./hardware-configuration.nix ];

  networking.hostName = "denkpad";
}
