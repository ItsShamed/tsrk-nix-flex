{ ... }:

{
  imports = [
    ./nvim-tree.nix
    ./treesitter.nix
    ./gitsigns.nix
    ./indentline.nix
    ./lsp.nix
    ./no-neck-pain.nix
    ./cmp.nix
    ./comment.nix
    ./project.nix
    ./telescope.nix
    ./which-key.nix
    ./alpha.nix
    ./dap.nix
    ./wakatime.nix
  ];

  plugins = {
    bufferline.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    surround.enable = true;
    notify.enable = true;
    nvim-autopairs.enable = true;
  };
}
