# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, pkgs }:

let
  packageNames = builtins.attrNames (import ./all-packages.nix);

  getPlatforms =
    drv:
    if drv ? meta && drv.meta ? platforms then
      drv.meta.platforms
    else
      lib.platforms.all;

  # This works because we assume that the provided pkgs has been modified by our
  # overlays
  drvs = lib.attrsets.filterAttrs (name: _: builtins.elem name packageNames) pkgs;
  # We only output packages available for the pkgs' system
in
lib.attrsets.filterAttrs (
  _: drv: builtins.elem pkgs.stdenv.hostPlatform.system (getPlatforms drv)
) drvs
