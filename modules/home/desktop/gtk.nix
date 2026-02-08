# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
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
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.tsrk.gtk;
  tokyonight =
    (pkgs.tokyonight-gtk-theme.override {
      colorVariants = [
        "dark"
        "light"
      ];
      tweakVariants = [ "storm" ];
      iconVariants = [
        "Dark"
        "Light"
      ];
    }).overrideAttrs
      { dontFixup = true; };
in
{
  options = {
    tsrk.gtk = {
      enable = lib.options.mkEnableOption "tsrk's GTK theming configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tsrkPkgs.modern-minimal-ui-sounds
      libcanberra-gtk3
    ];
    dconf.settings."org/gnome/desktop/sound" = {
      event-sounds = true;
      input-feedback-soudns = true;
    };
    gtk = {
      enable = true;
      gtk2.extraConfig = ''
        gtk-enable-event-sounds = 1
        gtk-enable-input-feedback-sounds = 1
        gtk-sound-theme-name = modern-minimal-ui
      '';
      gtk3.extraConfig = {
        gtk-enable-event-sounds = true;
        gtk-enable-input-feedback-sounds = true;
        gtk-sound-theme-name = "modern-minimal-ui";
      };
      gtk4.extraConfig = {
        gtk-enable-event-sounds = true;
        gtk-enable-input-feedback-sounds = true;
        gtk-sound-theme-name = "modern-minimal-ui";
      };
    };
    specialisation = {
      light.configuration = {
        gtk = {
          colorScheme = "light";
          theme = {
            name = "Tokyonight-Light-Storm";
            package = tokyonight;
          };
          iconTheme = {
            name = "Tokyonight-Light";
            package = tokyonight;
          };
        };
      };
      dark.configuration = {
        gtk = {
          colorScheme = "dark";
          theme = {
            name = "Tokyonight-Dark-Storm";
            package = tokyonight;
          };
          iconTheme = {
            name = "Tokyonight-Dark";
            package = tokyonight;
          };
        };
      };
    };
  };
}
