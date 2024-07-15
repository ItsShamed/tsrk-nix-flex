{ ... }:

{
  programs.nixvim = {
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
  };
}
