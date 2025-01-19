# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.eww = {
      enable = lib.options.mkEnableOption "tsrk's eww configuration bundle";
    };
  };

  config = lib.mkIf config.tsrk.eww.enable {
    programs.eww = {
      enable = lib.mkDefault true;
      configDir = lib.mkDefault ./.;
    };
  };
}
