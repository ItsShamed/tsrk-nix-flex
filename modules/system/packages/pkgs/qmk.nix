# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.packages.pkgs.qmk;
in {
  options = {
    tsrk.packages.pkgs.qmk = {
      enable = lib.options.mkEnableOption "tsrk's QMK package bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qmk
      qmk-udev-rules
      keymapviz
      dfu-util
      dfu-programmer
    ];

    hardware.keyboard.qmk.enable = lib.mkDefault true;
  };
}
