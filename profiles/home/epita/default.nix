# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [ epita profile-x11 ];

  tsrk.epita.cunix.enable = lib.mkDefault true;
}
