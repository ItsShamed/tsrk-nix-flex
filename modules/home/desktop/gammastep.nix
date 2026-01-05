# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.gammastep;
in
{
  options = {
    tsrk.gammastep = {
      enable = lib.options.mkEnableOption "tsrk's Gamma Step configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = lib.mkDefault true;
      enableVerboseLogging = lib.mkDefault true;
      settings.general.brightness-night = 0.45;
      temperature.day = 6500;
      temperature.night = 3000;
      latitude = 48.87951;
      longitude = 2.28513;
    };
  };
}
