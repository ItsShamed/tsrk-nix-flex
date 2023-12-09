{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions.fzf-native = {
      enable = true;
      fuzzy = true;
      overrideGenericSorter = true;
      overrideFileSorter = true;
      caseMode = "smart_case";
    };
    extensions.project-nvim.enable = true;

    extraOptions = {
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

  programs.nixvim.extraConfigLuaPost = ''
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
