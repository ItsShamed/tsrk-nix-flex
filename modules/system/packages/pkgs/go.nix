# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.pkgs.go;
in
{
  options = {
    tsrk.packages.pkgs.go = {
      enable = lib.options.mkEnableOption "Go package installation";
      ide.enable = lib.options.mkEnableOption "JetBrains GoLand (IDE for Go)";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        go
        gox
      ]
      ++ (lib.lists.optional cfg.ide.enable pkgs.jetbrains.goland);
  };
}
