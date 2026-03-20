# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      patterns = [
        ".git"
        "Makefile"
        "package.json"
        "pom.xml"
        "Cargo.toml"
        "go.mod"
        "*.sln"
        "Chart.yaml"
        "flake.nix"
      ];
    };
  };
}
