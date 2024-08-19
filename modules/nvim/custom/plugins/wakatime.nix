{ pkgs, config, helpers, ... }:

helpers.neovim-plugin.mkNeovimPlugin config {
  name = "vim-wakatime";
  originalName = "Vim Wakatime";
  defaultPackage = pkgs.vimPlugins.vim-wakatime;

  maintainers = [ ];

  callSetup = false;
}
