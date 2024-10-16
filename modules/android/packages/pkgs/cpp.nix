{ config, pkgs, lib, ... }:

let
  cfg = config.tsrk.packages.pkgs.cpp;
in
{
  options = {
    tsrk.packages.pkgs.cpp = {
      enable = lib.options.mkEnableOption "tsrk's C++ development bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.packages = with pkgs; [
      httplib
      libyamlcpp
    ];
  };
}
