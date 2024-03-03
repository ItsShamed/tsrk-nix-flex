{ config, lib, pkgs, ... }:

{
  programs.nixvim.plugins = {
    none-ls.enable = true;
    lsp-format.enable = true;
    lsp = {
      enable = true;
      keymaps.lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };

      servers = {
        clangd = {
          enable = true;
          package = pkgs.clang-tools_16;
        };
        cmake.enable = true;
        lua-ls.enable = true;
        nixd.enable = true;
        jsonls.enable = true;
        texlab.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
