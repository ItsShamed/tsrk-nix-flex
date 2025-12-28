# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

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
    assertions = [
      {
        assertion =
          (builtins.elem pkgs.mopidy-mpd config.services.mopidy.extensionPackages)
          -> !config.services.mpd.enable;
        message = "Mopidy-MPD cannot run concurrently with the original MPD";
      }
    ];

    programs.ncmpcpp.enable = lib.mkDefault true;

    services.mopidy = {
      enable = lib.mkDefault true;
      extensionPackages = with pkgs; [
        mopidy-mpd
        mopidy-mpris
        mopidy-local
        mopidy-youtube
        mopidy-scrobbler
      ];
      extraConfigFiles = [
        "${config.home.homeDirectory}/.config/mopidy/lastfm.conf"
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
