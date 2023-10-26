{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.containers.docker.enable = lib.options.mkEnableOption "Docker";
  };

  config = lib.mkIf config.tsrk.containers.docker.enable {
    tsrk.containers.enable = lib.mkDefault true;

    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
