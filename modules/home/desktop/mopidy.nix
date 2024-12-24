{ config, lib, pkgs, ... }:

let cfg = config.tsrk.mopidy;
in {
  options = {
    tsrk.mopidy = { enable = lib.options.mkEnableOption "Mopidy daemon"; };
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
      settings = rec {
        file = {
          enabled = true;
          media_dirs = [
            "${config.home.homeDirectory}/Music|${config.home.username}-Music"
          ];
          follow_symlinks = false;
          excluded_file_extensions = [
            ".directory"
            ".html"
            ".zip"
            ".jpg"
            ".jpeg"
            ".png"
            ".log"
            ".nfo"
            ".pdf"
            ".txt"
            ".zip"
          ];
          metadata_timeout = 10 * 1000;
        };
        local = {
          enabled = true;
          media_dir = "${config.home.homeDirectory}/Music";
          excluded_file_extensions = file.excluded_file_extensions;
          scan_timeout = file.metadata_timeout;
        };
        mpd.enabled = true;
        mpris.enabled = true;
        youtube = {
          enabled = true;
          allow_cache = true;
          musicapi_enabled = true;
        };
      };
    };
  };
}
