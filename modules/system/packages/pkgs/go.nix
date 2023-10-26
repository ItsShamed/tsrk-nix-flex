{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.go;
in
{
  options = {
    tsrk.packages.pkgs.go = {
      enable = lib.options.mkEnableOption "Go package installation";
      ide.enable = lib.options.mkEnableOption "JetBrains GoLand (IDE for Go)";
    };
  };

  config = lib.mkIg cfg.enable {
    environment.systemPackages = with pkgs; [
      go
      gox
    ] ++ (lib.lists.optional cfg.ide.enable pkgs.jetbrains.goland);
  };
}
