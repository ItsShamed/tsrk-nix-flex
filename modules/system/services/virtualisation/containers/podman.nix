{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.containers.podman.enable = lib.mkEnableOption "Podman";
  };

  config = {
    tsrk.containers.enable = lib.mkDefault true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        podman-compose
      ];
    };
  };
}
