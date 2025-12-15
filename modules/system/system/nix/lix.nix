# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsrk.lix;
in
{
  options = {
    tsrk.lix = {
      enable = lib.options.mkEnableOption "Lix as a replacement for Nix";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.package = pkgs.lixPackageSets.stable.lix;
    nixpkgs.overlays = [ self.overlays.lix-compat ];
  };
}
