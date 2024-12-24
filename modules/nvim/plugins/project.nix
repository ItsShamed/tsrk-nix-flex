# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      detection_methods = [ "pattern" ];
      manual_mode = false;

      ignore_lsp = [ ];
      show_hidde = false;
      silend_chdir = true;
      scope_chdir = "global";

      patterns = [
        ".git"
        "Makefile"
        "package.json"
        "pom.xml"
        "Cargo.toml"
        "go.mod"
        "*.sln"
      ];
    };
  };
}
