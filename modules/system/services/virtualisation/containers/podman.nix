{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.containers.podman.enable = lib.mkEnableOption "Podman";
  };

  config = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;

      defautltNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      compose
    ];
  };
}
