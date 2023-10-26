{ config, lib, ... }:

{
  imports = [
    ./docker.nix
    ./podman.nix
  ];

  options = {
    tsrk.containers.enable = lib.options.mkEnableOption "containers";
  };

  config = lib.mkIf config.tsrk.containers.enable {
    virtualisation.containers.registries.search = [ "docker.io" "ghcr.io" ];
  };
}
