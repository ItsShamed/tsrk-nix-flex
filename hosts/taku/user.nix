# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  pkgs,
  config,
  ...
}:

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
in
{

  imports = with self.homeManagerModules; [
    profile-wayland
    profile-work
    overlay-xivlauncher-rb
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

    hyprland.windowRules = {
      umineko-questions-arcs = {
        match.class = "^(Umineko1to4)$";
        float = true;
        content = "game";
      };
    };

    polybar = {
      ethInterfaceName = "enp16s0";
      wlanInterfaceName = "wlp15s0";
    };
    xsettingsd.withDConf = true;
    extPkgs = {
      xivlauncher-rb.install = true;
    };
  };

  home.packages = with pkgs; [
    tsrkPkgs.doukutsu-rs
    r2modman
    veloren
    airshipper
  ];

  services.syncthing = {
    enable = true;
    guiCredentials.username = config.home.username;
    settings = {
      devices = {
        gos = {
          id = "OGLQTMX-KHP3GQI-SWN6MHX-ZEE4TXN-PEO5DOW-4JHRWLS-OOWAJ2H-FS5TJA7";
          addresses = [
            "tcp://192.168.0.55"
            "dynamic"
          ];
        };
      };
      folders = {
        "${config.home.homeDirectory}/Music" = {
          id = "tsrk-music";
          devices = [
            "gos"
          ];
          type = "sendonly";
        };
      };
    };
  };

  services.pipewire = {
    enable = true;
    configs = {
      "10-18i8-mappings" =
        let
          mkOutMapping =
            name: outs:
            let
              logicalName = builtins.replaceStrings [ " " "/" ] [ "_" "" ] name;
            in
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "Scarlett 18i8 2nd Gen (${name})";
                "capture.props" = {
                  "node.name" = "Scarlett_18i8_2_${logicalName}";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.name" = "playback.Scarlett_18i8_2_${logicalName}";
                  "audio.position" = outs;
                  "target.object" =
                    "alsa_output.usb-Focusrite_Scarlett_18i8_USB_00054103-00.pro-output-0";
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
              };
            };
          mkInMapping =
            {
              name,
              logicalName,
              from,
              to,
            }:
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "${name}";
                "capture.props" = {
                  "node.name" = "capture.${logicalName}";
                  "audio.position" = from;
                  "target.object" =
                    "alsa_input.usb-Focusrite_Scarlett_18i8_USB_00054103-00.pro-input-0";
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
                "playback.props" = {
                  "node.name" = "${logicalName}";
                  "audio.position" = to;
                  "media.class" = "Audio/Source";
                };
              };
            };
        in
        {
          "context.modules" = [
            # Outputs
            (mkOutMapping "Monitor Output" [
              "AUX0"
              "AUX1"
            ])
            (mkOutMapping "Headphone 1" [
              "AUX2"
              "AUX3"
            ])
            (mkOutMapping "Headphone 2" [
              "AUX4"
              "AUX5"
            ])
            (mkOutMapping "S/PDIF Output" [
              "AUX6"
              "AUX7"
            ])
            # Inputs
            (mkInMapping {
              name = "Shure SM7B";
              logicalName = "Scarlett_18i8_2_Analogue_2";
              from = [ "AUX1" ];
              to = [ "MONO" ];
            })
          ];
        };
    };
    wireplumber = {
      enable = true;
      configs = {
        # Hides the virtual nodes that link to the actual i/o nodes bc it's
        # kinda stupid to let other Pipewire clients to get access to those
        # excpet for qpwgraph which is useful to debug this kind of stuff
        "10-hide-18i8-mapping-internal-virtual" = {
          "access.permission-managers" = [
            {
              name = "18i8_internal_virtual_hider";
              rules = [
                {
                  matches = [
                    {
                      "media.class" = "Stream/Output/Audio";
                      "node.virtual" = "true";
                      "target.object" = "~alsa_output\.usb-Focusrite_Scarlett_18i8.*";
                    }
                    {
                      "media.class" = "Stream/Input/Audio";
                      "node.virtual" = "true";
                      "target.object" = "~alsa_input\.usb-Focusrite_Scarlett_18i8.*";
                    }
                  ];
                  actions.set-permissions = "-";
                }
              ];
            }
          ];
          "access.rules" = [
            {
              matches = [
                { "application.name" = "!~\.?qpwgraph(-wrapped)?"; }
              ];
              actions = {
                update-props = {
                  permission_manager_name = "18i8_internal_virtual_hider";
                };
              };
            }
          ];
        };
      };
    };
  };
}
