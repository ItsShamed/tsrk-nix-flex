# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, ... }:

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
in
{

  imports = with self.homeManagerModules; [
    profile-wayland
    profile-work
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = {
      output = "DP-2";
      mode = "1920x1080@165";
      position = "0x0";
      scale = 1;
    };
    config.input.kb_layout = "us_qwerty-fr";
  };

  tsrk = {
    packages = {
      games.enable = true;
      more-gaming.enable = true;
      music-production = {
        enable = true;
        plugins.enable = true;
      };
      media.enable = true;
    };
    nvim.wakatime.enable = true;
    hyprland.uwsm.extraEnv = ''
      export AQ_DRM_DEVICES='/dev/dri/card0:/dev/dri/card1'
    '';
    polybar = {
      ethInterfaceName = "enp16s0";
      wlanInterfaceName = "wlp15s0";
    };
    xsettingsd.withDConf = true;
  };

  home.packages = with pkgs; [
    tsrkPkgs.doukutsu-rs
    r2modman
  ];
}
