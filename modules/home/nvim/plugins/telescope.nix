{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
  ];

  programs.nixvim.plugins.telescope = {
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
