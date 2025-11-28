# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.music-production;
in
{
  options = {
    tsrk.packages = {
      music-production = {
        enable = lib.options.mkEnableOption "the music production package bundle";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      furnace
      reaper
      reaper-reapack-extension
    ];
  };
}
