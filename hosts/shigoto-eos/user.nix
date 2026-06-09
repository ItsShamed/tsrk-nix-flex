# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  lib,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;
  toLua = lib.generators.toLua { };
in
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
        mkMonitor = output: mode: position: scale: {
          inherit
            output
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
        (
          (mkMonitor "desc:BNQ BenQ LCD R4L02809019" "2560x1440@60" "3840x0" 1)
          // {
            transform = 1;
          }
        )
      ];

    comsVerticalScrollingRule._var = mkLuaInline "hl.workspace_rule(${
      toLua {
        workspace = "4";
        layout_opts.direction = "down";
      }
    })";

    on = [
      {
        _args = [
          "hyprland.start"
          (mkLuaInline ''
            function()
              comsVerticalScrollingRule:set_enabled(false)
            end
          '')
        ];
      }
      {
        _args = [
          "monitor.added"
          (mkLuaInline ''
            function(m)
              if m.description == "BNQ BenQ LCD R4L02809019" then
                comsVerticalScrollingRule:set_enabled(true)
              elseif m.description == "Samsung Electric Company LS24AG30x H4PR90260" then
                hl.dispatch(hl.dsp.workspace.move({
                  workspace = "1",
                  monitor = "desc:" .. m.description
                }))
                hl.dispatch(hl.dsp.workspace.move({
                  workspace = "2",
                  monitor = "desc:" .. m.description
                }))
                hl.dispatch(hl.dsp.workspace.move({
                  workspace = "3",
                  monitor = "desc:" .. m.description
                }))
              end
            end
          '')
        ];
      }
      {
        _args = [
          "monitor.removed"
          (mkLuaInline ''
            function(m)
              if m.description == "BNQ BenQ LCD R4L02809019" then
                comsVerticalScrollingRule:set_enabled(false)
              end
            end
          '')
        ];
      }
    ];
    config.input.kb_layout = "us_qwerty-fr";
  };
  tsrk.hyprland = {
    workspaceRules = {
      "1" = {
        monitor = "desc:Iiyama North America PL2770H 0x30333736";
        default = true;
      };
      "2" = {
        monitor = "eDP-1";
        default = true;
      };
      "3" = {
        monitor = "desc:Iiyama North America PL2770H 0x31303331";
        default = true;
      };
      "4" = {
        monitor = "desc:BNQ BenQ LCD R4L02809019";
        default = true;
      };
    };
  };

  services.poweralertd.enable = true;

  # Somhow cava mutes the Jabra, it's quite annoying
  programs.cava.enable = false;
  programs.waybar.settings.main.modules-center = lib.mkImageMediaOverride [ ];
}
