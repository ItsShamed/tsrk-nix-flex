# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, config, ... }:

let
  host = config.lib.tsrk.imageName or (lib.warn
    "`lib.tsrk.imageName' was not specified, will be using 'unknown'"
    "unknown");
in {
  key = ./.;

  imports = with self.nixosModules; [ profile-base ];

  isoImage.isoName = lib.mkImageMediaOverride "nixos-tsrk-${host}.iso";
}
