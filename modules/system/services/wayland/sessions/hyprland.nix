# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.hyprland.enable =
      lib.options.mkEnableOption "Hyprland as a window manager";
  };

  config = lib.mkIf config.tsrk.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = lib.mkDefault true;
    };
    # Do not run Autostarts because if used alongside i3, picom will be deadge
    services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkForce false;
    security.pam.services.hyprlock.enable = lib.mkDefault true;
  };
}
