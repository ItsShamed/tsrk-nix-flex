# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgSet, ... }:

let
  inherit (pkgSet) pkgs;
in
config: command:

if (config.targets.genericLinux.enable) then
  "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${command}"
else
  command
