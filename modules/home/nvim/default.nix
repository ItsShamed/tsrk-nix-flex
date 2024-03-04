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
    colorscheme = lib.mkDefault "tokyonight-night";

    extraConfigVim = ''
      augroup highlight_yank
          autocmd!
          au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
      augroup END
    '';
  };
}
