# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.mpd;
in
{
  options = {
    tsrk.mpd = {
      enable = lib.options.mkEnableOption "tsrk's MPD setup";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd-discord-rpc = {
      enable = lib.mkDefault true;
      settings = {
        hosts = [ "localhost:6600" ];
        format = {
          id = 1454899796941869191;
          details = "$title";
          state = "$artist";
          large_text = "$album";
          small_image = "https://www.musicpd.org/logo.png";
        };
      };
    };
    services.mpdris2 = {
      enable = lib.mkDefault true;
      multimediaKeys = lib.mkDefault true;
    };
    programs.rmpc.enable = lib.mkDefault true;
    services.mpd = {
      enable = lib.mkDefault true;
    };
  };
}
