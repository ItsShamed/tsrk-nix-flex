{ config, lib, ... }:

{
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      indent.char = "▏";
      scope.char = "▏";
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
      scope.enabled = true;
    };
  };
}
