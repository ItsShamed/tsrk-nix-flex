# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.noice = {
    # TODO: Disabling this for the time being because LSP don't render correctly
    enable = false;
    # Suggested setup as shown in
    # https://github.com/folke/noice.nvim/?tab=readme-ov-file#-installation
    settings = {
      lsp = {
        override = {
          "cmp.entry.get_documentation" = true;
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
      };
    };
  };
}
