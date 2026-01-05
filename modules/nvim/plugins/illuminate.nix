# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.illuminate = {
    enable = true;
    delay = 120;
    filetypesDenylist = [
      "dirvish"
      "fugitive"
      "alpha"
      "NvimTree"
      "lazy"
      "Trouble"
      "lir"
      "Outline"
      "spectre_panel"
      "toggleterm"
      "DressingSelect"
      "TelescopePrompt"
    ];
  };
}
