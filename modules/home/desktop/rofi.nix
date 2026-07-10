# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    self.homeManagerModules.overlay-rofi-power-menu
    self.homeManagerModules.overlay-rofi-themes-collection
  ];

  options = {
    tsrk.rofi = {
      enable = lib.options.mkEnableOption "Rofi configuration";
    };
  };

  config = lib.mkIf config.tsrk.rofi.enable {
    tsrk.extPkgs.rofi-power-menu.install = true;
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
      theme = "${config.tsrk.extPkgs.rofi-themes-collection.firstPackage}/simple-tokyonight.rasi";
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
  };
}
