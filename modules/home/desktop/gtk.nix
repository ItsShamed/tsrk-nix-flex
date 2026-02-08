# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
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
    gtk.enable = lib.mkDefault true;
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
