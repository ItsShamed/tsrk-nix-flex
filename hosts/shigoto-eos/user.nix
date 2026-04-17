# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  lib,
  ...
}:

{
  imports = with self.homeManagerModules; [
    profile-wayland
    profile-work
  ];

  tsrk = {
    packages = {
      media.enable = true;
    };
    nvim.wakatime.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1200, 960x1080, 1"
      "desc:Samsung Electric Company LS24AG30x H4PR902603, 1920x1080@144, 960x0, 1"
      "desc:Iiyama North America PL2770H 0x31303331, 1920x1080@165, 0x0, 1"
      "desc:Iiyama North America PL2770H 0x30333736, 1920x1080@144, 1920x0, 1"
    ];
    workspace = [
      "1, monitor:desc:Iiyama North America PL2770H 0x31303331, default:true"
      "4, monitor:eDP-1, default:true"
      "2, monitor:desc:Iiyama North America PL2770H 0x30333736, default:true"
      "3, monitor:desc:Iiyama North America PL2770H 0x30333736, default:true"
      "1, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
      "2, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
      "3, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
    ];
    input.kb_layout = "us_qwerty-fr";
  };

  services.poweralertd.enable = true;

  # Somhow cava mutes the Jabra, it's quite annoying
  programs.cava.enable = false;
  programs.waybar.settings.main.modules-center = lib.mkImageMediaOverride [ ];
}
