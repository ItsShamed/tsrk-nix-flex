# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, inputs, ... }:

{
  languages.nix.enable = true;

  packages = with pkgs; [
    nix-output-monitor
    eww
    playerctl
    imagemagick
    inputs.agenix.packages.${pkgs.system}.default
  ];

  scripts.rebuild-os.exec = ''exec ${./rebuild-os.sh} "$@"'';
  scripts.gc.exec = ''exec ${./gc.sh} "$@"'';
  scripts.get-option.exec = ''exec ${./get_option.sh}"$@"'';
  scripts.rotate-bootstrap-keys.exec =
    ''exec ${./rotate_bootstrap_keys.sh}"$@"'';

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
