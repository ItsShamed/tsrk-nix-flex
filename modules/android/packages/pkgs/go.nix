{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.go;
in
{
  options = {
    tsrk.packages.pkgs.go = {
      enable = lib.options.mkEnableOption "Go package installation";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      go
      gox
    ];
  };
}
