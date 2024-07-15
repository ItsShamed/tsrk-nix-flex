{ ... }:

{
  imports = [
    ./nvim-tree.nix
    ./treesitter.nix
    ./indentline.nix
    ./lsp.nix
    ./cmp.nix
    ./comment.nix
    ./project.nix
    ./telescope.nix
    ./which-key.nix
    ./alpha.nix
    ./dap.nix
    ./wakatime.nix
  ];

  programs.nixvim.plugins = {
    bufferline.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    surround.enable = true;
    notify.enable = true;
    nvim-autopairs.enable = true;
  };
}
