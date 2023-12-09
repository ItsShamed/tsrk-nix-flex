{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins.illuminate = {
      enable = true;
      filetypesDenylist = [
        "dirvish"
        "fugitive"
        "alpha"
        "NvimTree"
        "lazy"
        "Trouble"
        "lir"
        "Outline"
        "spectre_panel"
        "toggleterm"
        "DressingSelect"
        "TelescopePrompt"
      ];
    };
  };
}
