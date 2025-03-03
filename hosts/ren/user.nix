# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, ... }:

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

  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;
    hooks.postswitch = { notify-i3 = "${pkgs.i3}/bin/i3-msg restart"; };
    profiles = {
      default = {
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0006af3d6800000000001d0104a51f117803b81aa6544a9b260e525500000001010101010101010101010101010101143780b87038244010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30362e38200a00c8";
        };
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
        };
      };
      forge-docked-1080p = {
        fingerprint = {
          DP-5 =
            "00ffffffffffff0026cd41618f090000181c0104a5351e783aee35a656529d280b5054b30c00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000fd00374c1e5311000a202020202020000000ff0031313634384d38363032343437000000fc00504c32343933480a202020202001e3020318f14b9002030411121305141f012309070183010000023a801871382d40582c45000f282100001e8c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e8c0ad090204031200c4055000f28210000180000000000000000000000000000000000000000000000000000000000000035";
          eDP-1 =
            "00ffffffffffff0006af3d6800000000001d0104a51f117803b81aa6544a9b260e525500000001010101010101010101010101010101143780b87038244010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30362e38200a00c8";
        };
        config = {
          eDP-1 = {
            enable = false;
            primary = false;
          };
          DP-5 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
          };
        };
      };
    };
  };
}
