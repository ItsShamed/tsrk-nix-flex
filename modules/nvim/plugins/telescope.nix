# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, ... }:

{
  plugins.telescope = {
    enable = true;
    extensions.fzf-native = {
      enable = true;
      settings = {
        fuzzy = true;
        override_generic_sorter = true;
        override_file_sorter = true;
        case_mode = "smart_case";
      };
    };

    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        entry_prefix = " ";
        initial_mode = "insert";
        selection_strategy = "reset";
        vimgrep_arguments = [
          "${pkgs.ripgrep}/bin/rg"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--hidden"
          "--glob=!.git/"
        ];
      };
    };
  };

  extraConfigLuaPost = ''
    local tsp_builtin = require("telescope.builtin")

    function find_project_files(opts)
      opts = opts or {}
      local ok = pcall(tsp_builtin.git_files, opts)

      if not ok then
        tsp_builtin.find_files(opts)
      end
    end
  '';
}
