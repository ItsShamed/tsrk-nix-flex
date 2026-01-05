# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      exclude.filetypes = [
        "help"
        "startify"
        "dashboard"
        "lazy"
        "NvimTree"
        "Trouble"
        "text"
        "lspinfo"
        "packer"
        "checkhealth"
        "help"
        "man"
        ""
      ];
      indent.char = "▏";
      scope = {
        enabled = true;
        char = "▏";
      };
    };
  };
}
