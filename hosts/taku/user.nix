# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{

  imports = with self.homeManagerModules; [ profile-wayland ];

  wayland.windowManager.hyprland.settings = {
    monitor = [ "DP-2, 1920x1080@165, 0x0, 1" ];
  };

  tsrk = {
    packages = {
      games.enable = true;
      more-gaming.enable = true;
      media.enable = true;
    };
    nvim.wakatime.enable = true;
    polybar = {
      ethInterfaceName = "enp16s0";
      wlanInterfaceName = "wlp15s0";
    };
    xsettingsd.withDConf = true;
  };
}
