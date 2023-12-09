{ config, lib, pkgs, ... }:

{
  imports = [
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    clipboard.providers = {
      xclip.enable = true;
      xsel.enable = true;
    };

    colorschemes.tokyonight.enable = true;
    colorscheme = "tokyonight";
  };
}
