# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, ... }:

{
  imports = with self.homeManagerModules; [ profile-tsrk-private ];

  tsrk = {
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
      ethInterfaceName = "enp4s0f4u1u4";
      backlightCard = "amdgpu_bl1";
      battery = {
        enable = true;
        battery = "BAT1";
        adapter = "ACAD";
      };
    };
    nvim.wakatime.enable = true;
  };

  services.poweralertd.enable = true;

  programs.autorandr = {
    enable = true;
    hooks.postswitch = { notify-i3 = "${pkgs.i3}/bin/i3-msg restart"; };
    profiles = let
      dockedProfile1080p = monitor: {
        fingerprint.${monitor} =
          "00ffffffffffff0026cd41618f090000181c0104a5351e783aee35a656529d280b5054b30c00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000fd00374c1e5311000a202020202020000000ff0031313634384d38363032343437000000fc00504c32343933480a202020202001e3020318f14b9002030411121305141f012309070183010000023a801871382d40582c45000f282100001e8c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e8c0ad090204031200c4055000f28210000180000000000000000000000000000000000000000000000000000000000000035";
        config = {
          eDP-1 = {
            enable = false;
            primary = false;
          };
          "${monitor}" = {
            enable = true;
            primary = true;
            mode = "1920x1080";
          };
        };
      };
      doubleDockedMaxxing = horiMonitor: vertMonitor: {
        fingerprint = {
          ${horiMonitor} =
            "00ffffffffffff0010ac46424c3738392c1f0104b54627783a6875a6564fa2260e5054a54b00e1c0d100d1c0b300a94081808100714f4dd000a0f0703e8030203500b9882100001a000000ff0036384d535847330a2020202020000000fd00184b1e8c3c010a202020202020000000fc0044454c4c20503332323251450a01ca02030eb1495f101f200413121101a36600a0f0703e8030203500b9882100001a565e00a0a0a0295030203500b9882100001a114400a08000255030203600b9882100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000048";
          ${vertMonitor} =
            "00ffffffffffff0026cd4161f1020000181c0104a5351e783aee35a656529d280b5054b30c00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000fd00374c1e5311000a202020202020000000ff0031313634384d38363030373533000000fc00504c32343933480a2020202020018a020318f14b9002030411121305141f012309070183010000023a801871382d40582c45000f282100001e8c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e8c0ad090204031200c4055000f28210000180000000000000000000000000000000000000000000000000000000000000035";
        };
        hooks.postswitch = ''
          xrandr --fb 6000x6000
          echo 'Xft.dpi: 144' | xrdb -override -
          ${pkgs.i3}/bin/i3-msg 'workspace "4: coms"'
          ${pkgs.i3}/bin/i3-msg 'move workspace to output ${vertMonitor}'
          ${pkgs.i3}/bin/i3-msg '[class="thunderbird"] layout splitv'
          ${pkgs.i3}/bin/i3-msg 'workspace back_and_forth'
        '';
        config = {
          eDP-1 = {
            enable = false;
            primary = false;
          };
          "${horiMonitor}" = {
            enable = true;
            primary = true;
            mode = "3840x2160";
            dpi = 144;
          };
          "${vertMonitor}" = {
            enable = true;
            mode = "1920x1080";
            scale = rec {
              x = 1.5;
              y = x;
            };
            rotate = "left";
            position = "3840x0";
          };
        };
      };
    in {
      default = {
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0006af3d6800000000001d0104a51f117803b81aa6544a9b260e525500000001010101010101010101010101010101143780b87038244010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30362e38200a00c8";
        };
        hooks.postswitch = ''
          xrandr --fb 1920x1080
          echo 'Xft.dpi: 96' | xrdb -override -
          ${pkgs.i3}/bin/i3-msg 'workspace "4: coms"'
          ${pkgs.i3}/bin/i3-msg 'move workspace to output eDP-1'
          ${pkgs.i3}/bin/i3-msg '[class="thunderbird"] layout splith'
          ${pkgs.i3}/bin/i3-msg 'workspace back_and_forth'
        '';
        config = {
          HDMI-1 = {
            enable = false;
            primary = false;
          };
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
          };
          DP-1 = {
            enable = false;
            primary = false;
          };
          DP-4 = {
            enable = false;
            primary = false;
          };
          DP-5 = {
            enable = false;
            primary = false;
          };
        };
      };
      docked-HDMI-1 = dockedProfile1080p "HDMI-1";
      docked-DP-4 = dockedProfile1080p "DP-4";
      docked-DP-5 = dockedProfile1080p "DP-5";
      double-docked-DP-5-DP-3 = doubleDockedMaxxing "DP-5" "DP-3";
      double-docked-DP-3-DP-4 = doubleDockedMaxxing "DP-4" "DP-3";
      double-docked-DP-6-DP-5 = doubleDockedMaxxing "DP-6" "DP-5";
    };
  };
}
