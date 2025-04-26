# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, ... }:

{
  imports = with self.homeManagerModules; [
    profile-tsrk-private
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [ "com.fightcade.Fightcade" ];
    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
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
  };
}
