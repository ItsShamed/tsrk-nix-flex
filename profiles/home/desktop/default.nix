# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, options, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [
    profile-base

    darkman
    eww
    flameshot
    gammastep
    kitty
    premid
    rofi
    screenkey
    session-targets
    thunderbird
    xdg
  ];

  config = {
    tsrk = {
      darkman = {
        enable = lib.mkDefault true;
        nvim.enable = lib.mkDefault true;
      };
      gammastep.enable = lib.mkDefault true;
      kitty.enable = lib.mkDefault true;
      screenkey = {
        enable = lib.mkDefault true;
        settings = options.tsrk.screenkey.settings.default // {
          timeout = 0.5;
          font_desc = "IosevkaTerm Nerd Font 10";
          font_size = "small";
          font_color = "#c0c0cacaf5f5";
          bg_color = "#242428283b3b";
          opacity = 0.5;
          mouse = true;
          button_hide_duration = 0.5;
        };
      };
      sessionTargets.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
      xdg.enable = lib.mkDefault true;
    };

    # Set GTK as QT platform theme to unify theming
    home.sessionVariables = {
      GDK_BACKEND = "wayland,x11,*";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "gtk3";
      XCURSOR_SIZE = 48;
    };
  };
}
