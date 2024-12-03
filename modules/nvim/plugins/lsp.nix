{ pkgs, ... }:

{
  plugins = {
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
        autotools_ls.enable = true;
        clangd = {
          enable = true;
          package = pkgs.clang-tools_16;
        };
        cmake.enable = true;
        dockerls = {
          enable = true;
          settings = {
            docker.languageserver.formatter.ignoreMultilineInstructions = true;
          };
        };
        eslint.enable = true;
        helm_ls = {
          enable = true;
          cmd = [ "${pkgs.helm-ls}/bin/helm_ls" ];
        };
        lua_ls.enable = true;
        nixd = {
          enable = true;
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
            options = {
              nixos.expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).lspHints.nixos or {}";
              homeManager.expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).lspHints.homeManager or {}";
            };
          };
        };
        jsonls.enable = true;
        texlab.enable = true;
        yamlls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
      };
    };
  };
}
