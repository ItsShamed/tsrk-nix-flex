{ ... }:

{
  imports = [
    ./nvim-tree.nix
    ./treesitter.nix
    ./gitsigns.nix
    ./indentline.nix
    ./lsp.nix
    ./markview.nix
    ./no-neck-pain.nix
    ./cmp.nix
    ./comment.nix
    ./project.nix
    ./telescope.nix
    ./which-key.nix
    ./alpha.nix
    ./dap.nix
  ];

  plugins = {
    web-devicons.enable = true;
    bufferline.enable = true;
    hardtime.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    vim-surround.enable = true;
    notify.enable = true;
    nvim-autopairs.enable = true;
    todo-comments.enable = true;
    helm.enable = true;
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    }
  ];
}
