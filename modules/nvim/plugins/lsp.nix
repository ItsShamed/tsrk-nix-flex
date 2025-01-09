# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, lib, ... }:

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
        ltex = {
          enable = true;
          settings = {
            # NOTE: Docs say this only detects English or German but I think
            # this is bullshit. Audited LT's source code and they seem to be
            # doing fine at detecting languages based on spelling mistakes.
            language = "auto";
            additionalRules.motherTongue = lib.mkDefault "fr";
          };
        };
        lua_ls.enable = true;
        nixd = {
          enable = true;
          settings = {
            formatting.command = [ "nixfmt" ];
            options = {
              nixos.expr = ''
                (builtins.getFlake ("git+file://" + toString ./.)).lspHints.nixos or {}'';
              homeManager.expr = ''
                (builtins.getFlake ("git+file://" + toString ./.)).lspHints.homeManager or {}'';
              nixvim.expr = ''
                (builtins.getFlake ("git+file://" + toString ./.)).packages.${pkgs.system}.nvim-cirno.options or {}
              '';
            };
          };
        };
        jsonls.enable = true;
        texlab.enable = true;
        tinymist = {
          enable = true;
          extraOptions = {
            # TODO: Remove this when NeoVim 0.10.3 is relased
            offset_encoding = "utf-8";
          };
          settings = {
            formatterMode = "typstyle";
            formatterPrintWidth = "80";
          };
        };
        vala_ls.enable = true;
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
