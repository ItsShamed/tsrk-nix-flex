{
  imports = [ ./custom/plugins ./keymaps.nix ./options.nix ./plugins ];

  clipboard.register = "unnamedplus";
  clipboard.providers = {
    xclip.enable = true;
    xsel.enable = true;
  };

  colorschemes.tokyonight.enable = true;
  colorscheme = "tokyonight-storm";

  extraConfigVim = ''
      augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
    augroup END
  '';
}
