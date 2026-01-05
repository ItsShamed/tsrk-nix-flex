# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.sddm;
  theme = pkgs.sddm-slice-theme.withConfig {
    color_bg = "#24283b";
    color_contrast = "#1f2335";
    color_dimmed = "#a9b1d6";
    color_main = "#c0caf5";
  };
in
{
  options = {
    tsrk.sddm = {
      enable = lib.options.mkEnableOption "sddm as a display manager";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = with self.overlays; [
      sddm
      sddm-slice-theme
    ];
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      theme = "${theme}/share/sddm/themes/slice";
      settings.Theme = {
        CursorTheme = "macOS";
        CursorSize = 48;
      };
    };

    environment.systemPackages = [
      theme
      pkgs.apple-cursor
    ];
  };
}
