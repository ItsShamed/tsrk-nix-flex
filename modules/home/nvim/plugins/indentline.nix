{ config, lib, ... }:

{
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      char = "▏";
      contextChar = "▏";
      filetypeExclude = [
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
      useTreesitter = true;
      showCurrentContext = true;
    };
  };
}
