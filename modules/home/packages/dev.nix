# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, pkgs, ... }:

let
  tsrkPkgs = self.packages.${pkgs.system};
  cfg = config.tsrk.packages.dev;
in {
  options = {
    tsrk.packages.dev = {
      enable = lib.options.mkEnableOption "tsrk's development bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ tsrkPkgs.realm-studio devenv ];
  };
}
