# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  imports = [ ./custom/plugins ./keymaps.nix ./options.nix ./plugins ];

  clipboard.register = "unnamedplus";
  clipboard.providers = {
    xclip.enable = true;
    xsel.enable = true;
  };

  colorschemes.tokyonight.enable = true;
  colorscheme = "tokyonight-storm";

  extraConfigVim = ''
      augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
    augroup END
  '';
}
