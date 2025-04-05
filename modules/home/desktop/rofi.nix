# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ pkgs, lib, config, ... }:

let tsrkPkgs = self.packages.${pkgs.system};
in {
  options = {
    tsrk.rofi = { enable = lib.options.mkEnableOption "Rofi configuration"; };
  };

  config = lib.mkIf config.tsrk.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [ rofi-emoji-wayland rofi-rbw ];
      theme = "${tsrkPkgs.rofi-themes-collection}/simple-tokyonight.rasi";
      terminal = (self.lib.mkIfElse (config.programs.kitty.enable) "kitty"
        "${pkgs.alacritty}/bin/alacritty");
      location = "center";
      extraConfig = {
        modi = "drun,run";
        font = "Iosevka Nerd Font 12";
        show-icons = true;
      };
    };

    home.packages = with pkgs; [ rofi-power-menu ];
  };
}
