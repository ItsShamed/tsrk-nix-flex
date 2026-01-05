# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./x11-base.nix;

  imports = with self.homeManagerModules; [
    profile-desktop
    i3
    polybar
  ];

  config = {
    tsrk = {
      i3.enable = lib.mkDefault true;
      polybar.enable = lib.mkDefault true;
    };
  };
}
