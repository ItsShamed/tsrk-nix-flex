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
    monitor =
      let
        mkMonitor = name: mode: position: scale: {
          inherit
            name
            mode
            position
            scale
            ;
        };
      in
      [
        # Built-in
        (mkMonitor "eDP-1" "1920x1200" "1920x1080" 1)
        # Home
        (mkMonitor "desc:Samsung Electric Company LS24AG30x H4PR902603" "1920x1080@144"
          "1920x0"
          1
        )
        # Left
        (mkMonitor "desc:Iiyama North America PL2770H 0x31303331" "1920x1080@165" "0x0"
          1
        )
        # Center
        (mkMonitor "desc:Iiyama North America PL2770H 0x30333736" "1920x1080@144"
          "1920x0"
          1
        )
        # Right (vertical)
        (mkMonitor "desc:BNQ BenQ LCD R4L02809019" "2560x1440@60" "3840x0" "1"
          "transform"
          1
        )
      ];
    workspace_rule =
      let
        mkMonitorMap = id: monitor: {
          workspace = toString id;
          inherit monitor;
          default = true;
        };
      in
      [
        (mkMonitorMap 1 "desc:Iiyama North America PL2770H 0x30333736")
        (mkMonitorMap 2 "eDP-1")
        (mkMonitorMap 3 "desc:Iiyama North America PL2770H 0x31303331")
        (mkMonitorMap 4 "desc:BNQ BenQ LCD R4L02809019")
        (mkMonitorMap 1 "desc:Samsung Electric Company LS24AG30x H4PR90260")
        (mkMonitorMap 2 "desc:Samsung Electric Company LS24AG30x H4PR90260")
        (mkMonitorMap 3 "desc:Samsung Electric Company LS24AG30x H4PR90260")
      ];
    workspace = [
      "1, monitor:desc:Iiyama North America PL2770H 0x30333736, default:true"
      "2, monitor:eDP-1, default:true"
      "3, monitor:desc:Iiyama North America PL2770H 0x31303331, default:true"
      "4, monitor:desc:BNQ BenQ LCD R4L02809019, default:true"
      "1, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
      "2, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
      "3, monitor:desc:Samsung Electric Company LS24AG30x H4PR90260, default:true"
    ];
    config.input.kb_layout = "us_qwerty-fr";
  };

  services.poweralertd.enable = true;

  # Somhow cava mutes the Jabra, it's quite annoying
  programs.cava.enable = false;
  programs.waybar.settings.main.modules-center = lib.mkImageMediaOverride [ ];
}
