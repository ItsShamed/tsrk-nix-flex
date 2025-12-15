# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgSet, ... }:

pkgs: config: command:

let
  overlaidPkgs = (pkgSet pkgs.stdenv.hostPlatform.system).pkgs;
in
if (config.targets.genericLinux.enable) then
  "${overlaidPkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${command}"
else
  command
