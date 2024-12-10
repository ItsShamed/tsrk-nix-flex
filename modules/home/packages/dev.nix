{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.dev;
in
{
  options = {
    tsrk.packages.dev = {
      enable = lib.options.mkEnableOption "tsrk's development bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      realm-studio
      devenv
    ];
  };
}
