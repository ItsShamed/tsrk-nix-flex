# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
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
  cfg = config.tsrk.screenkey;
in
{
  options = {
    tsrk.screenkey = {
      enable = lib.options.mkEnableOption "Screenkey";
      settings = lib.options.mkOption {
        description = "Settings to configure Screenkey";
        type = lib.types.attrs;
        default = {
          "no_systray" = false;
          "timeout" = 2;
          "recent_thr" = 0.1;
          "compr_cnt" = 5;
          "ignore" = [ ];
          "position" = "fixed";
          "persist" = false;
          "window" = null;
          "font_desc" = "Sans Bold";
          "font_size" = "small";
          "font_color" = "#ffffffffffff";
          "bg_color" = "#000000000000";
          "opacity" = 0.8;
          "key_mode" = "composed";
          "bak_mode" = "baked";
          "mods_mode" = "normal";
          "mods_only" = false;
          "multiline" = false;
          "vis_shift" = false;
          "vis_space" = true;
          "geometry" = [
            1493
            1046
            427
            34
          ];
          "screen" = 0;
          "start_disabled" = false;
          "mouse" = false;
          "button_hide_duration" = 1;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ screenkey ];

    xdg.configFile."screenkey.json".text = builtins.toJSON cfg.settings;
  };
}
