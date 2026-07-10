# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.dev;
in
{
  imports = with self.homeManagerModules; [ overlay-realm-studio ];

  options = {
    tsrk.packages.dev = {
      enable = lib.options.mkEnableOption "tsrk's development bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    tsrk.extPkgs.realm-studio.install = true;

    home.packages = with pkgs; [
      devenv
    ];
  };
}
