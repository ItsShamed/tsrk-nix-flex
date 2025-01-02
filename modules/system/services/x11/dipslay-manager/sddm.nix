# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.sddm = {
      enable = lib.options.mkEnableOption "sddm as a display manager";
    };
  };

  config = lib.mkIf config.tsrk.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      theme = "slice";
    };

    environment.systemPackages = [
      (pkgs.sddm-slice-theme.withConfig {
        color_bg = "#24283b";
        color_contrast = "#1f2335";
        color_dimmed = "#a9b1d6";
        color_main = "#c0caf5";
      })
    ];
  };
}
