# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.python;
  tsrkPythonPackages = pythonPackages:
    with pythonPackages; [
      pip
      virtualenv
      ipython
      pytest
      pyyaml
    ];
  extraPythonPackages = lib.attrsets.attrValues cfg.extraPackages;
  resultingPythonPackages = ps:
    lib.lists.flatten (builtins.map (pkgList: pkgList ps)
      ([ tsrkPythonPackages ] ++ extraPythonPackages));
in {
  options = {
    tsrk.packages.pkgs.python = {
      enable = lib.options.mkEnableOption "tsrk's Python bundle";
      extraPackages = lib.options.mkOption {
        default = { };
        type = with lib.types; attrsOf (functionTo (listOf package));
        description = "Extra Python packages to install.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        ((python3.withPackages resultingPythonPackages).override
          (_: { ignoreCollisions = true; }))
      ];
  };
}
