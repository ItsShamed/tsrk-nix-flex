{ ... }:

{
  imports = [
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard.register = "unnamedplus";
    clipboard.providers = {
      xclip.enable = true;
      xsel.enable = true;
    };

    colorschemes.tokyonight.enable = true;
    colorscheme = "tokyonight-night";

    extraConfigVim = ''
      augroup highlight_yank
          autocmd!
          au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
      augroup END
    '';
  };
}
