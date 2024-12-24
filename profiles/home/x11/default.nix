# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, options, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [
    darkman
    dunst
    flameshot
    music-player
    picom
    premid
    profile-x11-base
    rofi
    screenkey
    thunderbird
    xdg
    xsettingsd
  ];

  config = {
    tsrk = {
      i3.exitPromptCommand = lib.mkDefault (teardown:
        "exec rofi -show p -modi p:'rofi-power-menu --logout ${teardown}'");
      xdg.enable = true;
      packages.desktop.enable = lib.mkDefault true;
      darkman = {
        enable = lib.mkDefault true;
        feh = {
          enable = lib.mkDefault true;
          dark = lib.mkDefault ./files/cirnix-bg-dark.png;
          light = lib.mkDefault ./files/cirnix-bg-light.png;
        };
        nvim.enable = lib.mkDefault true;
      };
      dunst.enable = lib.mkDefault true;
      flameshot.enable = lib.mkDefault true;
      # Currently it seems like the scanned is no-oped so it seemingly does
      # nothing yet.
      # music-player.enable = lib.mkDefault true;
      picom.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
      xsettingsd.enable = lib.mkDefault true;
      polybar.mpris.enable = lib.mkDefault true;
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
    };
  };
}
