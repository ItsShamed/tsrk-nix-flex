# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./wayland-base.nix;

  imports = with self.homeManagerModules; [ profile-desktop hyprland ];

  config = {
    # a
    tsrk = {
      # a
      hyprland.enable = lib.mkDefault true;
    };
  };
}
