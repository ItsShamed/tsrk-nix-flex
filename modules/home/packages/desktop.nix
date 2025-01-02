# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.packages.desktop = {
      enable = lib.options.mkEnableOption "tsrk's desktop package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.desktop.enable {
    home.packages = with pkgs; [
      # Discord replacement
      vesktop
      legcord

      # Fonts
      (nerdfonts.override {
        fonts = [ "Iosevka" "IosevkaTerm" "JetBrainsMono" "Meslo" ];
      })
      iosevka
      meslo-lgs-nf
      libreoffice
      xfce.thunar
      ranger

      # The best password manager (real)
      bitwarden
      spotify-adblock
    ];
  };
}
