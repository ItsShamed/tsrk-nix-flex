{ config, lib, ... }:

{
  imports = [
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  options = {
    tsrk.nvim = {
      enable = lib.options.mkEnableOption "tsrk's nvim configuration";
    };
  };

  config = lib.mkIf config.tsrk.nvim.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      clipboard.register = "unnamedplus";
      clipboard.providers = {
        xclip.enable = true;
        xsel.enable = true;
      };

      colorschemes.tokyonight.enable = true;
      colorscheme = "tokyonight";

      extraConfigVim = ''
          augroup highlight_yank
          autocmd!
          au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
        augroup END
      '';
    };
  };
}
