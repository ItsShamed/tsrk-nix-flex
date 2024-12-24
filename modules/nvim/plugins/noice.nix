{ ... }:

{
  plugins.noice = {
    enable = true;
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
