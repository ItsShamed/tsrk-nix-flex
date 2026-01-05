# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./graphical-x11.nix;

  imports = [
    self.nixosModules.profile-graphical-base
    self.nixosModules.i3
    self.nixosModules.overlay-rofi-power-menu
  ];

  tsrk.i3.enable = lib.mkDefault true;
}
