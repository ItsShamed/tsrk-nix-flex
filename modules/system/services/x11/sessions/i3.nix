# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.i3.enable = lib.options.mkEnableOption "i3 as a window manager";
  };

  config = lib.mkIf config.tsrk.i3.enable {
    services.xserver.windowManager.i3 = {
      enable = true;
    };
    security.pam.services = {
      i3lock.enable = true;
      i3lock-color.enable = true;
    };
  };
}
