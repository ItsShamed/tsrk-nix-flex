{ config, lib, ... }:

let
  cfg = config.tsrk.networking.networkmanager;
in
{
  options = {
    tsrk.networking.networkmanager = {
      enable = lib.options.mkEnableOption "NetworkManager";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = lib.mkDefault true;
    };

    programs.nm-applet.enable = lib.mkDefault true;
  };
}
