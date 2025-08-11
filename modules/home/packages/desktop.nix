# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ pkgs, lib, config, ... }:

let tsrkPkgs = self.packages.${pkgs.system};
in {
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
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      corefonts
      iosevka
      meslo-lgs-nf
      libreoffice
      xfce.thunar
      ranger

      # The best password manager (real)
      bitwarden
      tsrkPkgs.spotify-adblock

      # PDF Readers
      zathura # TODO: Make HM Module
      evince
    ];
  };
}
