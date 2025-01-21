# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  options = { tsrk.bluetooth.enable = lib.options.mkEnableOption "Bluetooth"; };

  config = lib.mkIf config.tsrk.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez-tools
      blueberry
      overskride
    ];

    services.pipewire.wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = false;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" =
            [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" ];
        };
      };
    };
  };
}
