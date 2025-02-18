# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  imports = [
    ./nvim-tree.nix
    ./treesitter.nix
    ./gitsigns.nix
    ./indentline.nix
    ./lsp.nix
    ./luasnip.nix
    ./markdown-preview.nix
    ./markview.nix
    ./noice.nix
    ./no-neck-pain.nix
    ./cmp.nix
    ./comment.nix
    ./project.nix
    ./telescope.nix
    ./which-key.nix
    ./alpha.nix
    ./dap.nix
  ];

  plugins = {
    web-devicons.enable = true;
    bufferline.enable = true;
    hardtime.enable = true;
    image.enable = true;
    lualine.enable = true;
    vim-surround.enable = true;
    notify.enable = true;
    nui.enable = true;
    nvim-autopairs.enable = true;
    todo-comments.enable = true;
    helm.enable = true;
  };

  autoCmd = [{
    event = "FileType";
    pattern = "helm";
    command = "LspRestart";
  }];
}
