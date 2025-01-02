# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, inputs, ... }:

{
  languages.nix.enable = true;

  packages = with pkgs; [
    nix-output-monitor
    inputs.agenix.packages.${pkgs.system}.default
  ];

  git-hooks = {
    hooks = {
      deadnix = {
        enable = true;
        settings = {
          edit = true;
          noLambdaArg = true;
        };
      };
      nixfmt-classic = {
        enable = true;
        settings = { width = 80; };
      };
    };
  };
}
