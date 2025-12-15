# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgSet, ... }:

{
  pkgs,
  lib,
  config,
  options,
  ...
}:

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  overlaidPkgs = (pkgSet pkgs.stdenv.hostPlatform.system).pkgs;
  canUseOverlays = options.nixpkgs.overlays.visible;
  # Circumvent the fact that people with `home-manager.useGlobalPkgs` cannot use
  # overlays, so we have to provide our own overlaid pkgs (which will definitely
  # increase evaluation smhh)
  rofi-power-menu-fix =
    (if canUseOverlays then pkgs else overlaidPkgs).rofi-power-menu;
in
{
  options = {
    tsrk.rofi = {
      enable = lib.options.mkEnableOption "Rofi configuration";
    };
  };

  config = lib.mkIf config.tsrk.rofi.enable {
    nixpkgs.overlays = lib.mkIf canUseOverlays [
      self.overlays.rofi-power-menu
    ];
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
      theme = "${tsrkPkgs.rofi-themes-collection}/simple-tokyonight.rasi";
      terminal = (
        self.lib.mkIfElse (config.programs.kitty.enable
        ) "kitty" "${pkgs.alacritty}/bin/alacritty"
      );
      location = "center";
      extraConfig = {
        modi = "drun,run";
        font = "Iosevka Nerd Font 12";
        show-icons = true;
      };
    };

    home.packages = [ rofi-power-menu-fix ];
  };
}
