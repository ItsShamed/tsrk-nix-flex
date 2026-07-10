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
  imports = with self.homeManagerModules; [ overlay-spotify-adblock ];

  options = {
    tsrk.packages.desktop = {
      enable = lib.options.mkEnableOption "tsrk's desktop package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.desktop.enable {
    tsrk.extPkgs.spotify-adblock.install = true;

    home.packages = with pkgs; [
      # Discord replacement
      vesktop
      legcord

      # Fonts
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      corefonts
      iosevka
      meslo-lgs-nf
      libreoffice
      thunar
      ranger

      # PDF Readers
      zathura # TODO: Make HM Module
      evince
    ];
  };
}
