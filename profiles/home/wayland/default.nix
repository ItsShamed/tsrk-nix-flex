# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

# deadnix: skip
{ lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [
    profile-wayland-base
    xsettingsd
    syshud
  ];

  config = {
    tsrk = {
      syshud.enable = lib.mkDefault true;
      xsettingsd = {
        enable = lib.mkDefault true;
        withDConf = lib.mkDefault true;
      };
    };
  };
}
