# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [
    dunst
    picom
    profile-x11-base
    xsettingsd
  ];

  config = {
    tsrk = {
      i3.exitPromptCommand = lib.mkDefault (
        teardown: "exec rofi -show p -modi p:'rofi-power-menu --logout ${teardown}'"
      );
      packages.desktop.enable = lib.mkDefault true;
      darkman = {
        feh = {
          enable = lib.mkDefault true;
          dark = lib.mkDefault ./files/cirnix-bg-dark.png;
          light = lib.mkDefault ./files/cirnix-bg-light.png;
        };
      };
      dunst.enable = lib.mkDefault true;
      flameshot.enable = lib.mkDefault true;
      # Currently it seems like the scanned is no-oped so it seemingly does
      # nothing yet.
      # music-player.enable = lib.mkDefault true;
      eww.enable = lib.mkDefault true;
      picom.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
      xsettingsd.enable = lib.mkDefault true;
      polybar.mpris.enable = lib.mkDefault true;
    };
  };
}
