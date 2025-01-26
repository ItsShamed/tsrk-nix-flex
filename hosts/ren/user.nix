# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  imports = with self.homeManagerModules; [ profile-tsrk-private ];

  tsrk = {
    i3.lockerBackground = ../../modules/home/desktop/files/bg-no-logo.png;
    packages = {
      games.enable = true;
      more-gaming.enable = true;
      media.enable = true;
    };
    darkman = {
      feh = {
        dark = ./files/bocchi-tokyonight-storm.png;
        light = ./files/lagtrain-tokyonight-day.png;
      };
    };
    polybar = {
      wlanInterfaceName = "wlp1s0";
      backlightCard = "amdgpu_bl1";
      battery = {
        enable = true;
        battery = "BAT1";
        adapter = "ACAD";
      };
    };
    nvim.wakatime.enable = true;
  };
}
