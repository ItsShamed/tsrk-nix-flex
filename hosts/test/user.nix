# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [ "Virtual-1,1800x900@60.000Hz,0x0,1" ];
  };

  tsrk.picom.enable = lib.mkImageMediaOverride false;
  programs.waybar.systemd.enableInspect = lib.mkDefault true;
}
