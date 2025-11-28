# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./wayland-base.nix;

  imports = with self.homeManagerModules; [
    profile-desktop
    hyprland
    waybar
  ];

  config = {
    tsrk = {
      hyprland.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
    };
    xdg.configFile."uwsm/env" = {
      text = ''
        # Unset GTK_IM_MODULE for Fcitx to work optimally
        if printenv GTK_IM_MODULE >/dev/null; then
          unset GTK_IM_MODULE
        fi

        export USE_WAYLAND_GRIM=1
        export QT_IM_MODULES='wayland;fcitx;ibus'
        export SDL_VIDEODRIVER='wayland,x11,*'
        export CLUTTER_BACKEND=wayland
      '';
    };
  };
}
