# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      ensure_installed = [
        "bash"
        "c"
        "javascript"
        "json"
        "lua"
        "python"
        "typescript"
        "tsx"
        "css"
        "rust"
        "java"
        "yaml"
        "vala"
      ];
    };
  };
}
