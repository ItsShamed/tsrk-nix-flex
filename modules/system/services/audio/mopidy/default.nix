{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.mopidy;
in
{
  options = {
    tsrk.mopidy = {
      enable = lib.options.mkEnableOption "Mopidy daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mopidy = {
      enable = lib.mkDefault true;
      extensionPackages = with pkgs; [
        mopidy-mpd
        mopidy-mpris
        mopidy-local
        mopidy-youtube
      ];
      extraConfigFiles = [
        "${./config/file.conf}"
        "${./config/local.conf}"
        "${./config/mpd.conf}"
        "${./config/mpris.conf}"
        "${./config/youtube.conf}"
      ];
    };
  };
}
