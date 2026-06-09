# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  pkgs,
  lib,
  config,
  ...
}:

let
  lspconfig_keymaps = {
    K = "hover";
    gD = "references";
    gd = "definition";
    gi = "implementation";
    gt = "type_definition";
  };
  lspconfig_compat = lib.mapAttrsToList (key: lspBufAction: {
    inherit key lspBufAction;
    mode = "n";
  }) lspconfig_keymaps;
in
{
  plugins = {
    none-ls.enable = true;
    lsp-format.enable = true;
    lspconfig.enable = true;
  };
  lsp = {
    keymaps = lspconfig_compat ++ [

    ];
    inlayHints.enable = true;
    servers = {
      autotools_ls.enable = true;
      clangd.enable = true;
      cmake.enable = true;
      dockerls = {
        enable = true;
        config.settings = {
          docker.languageserver.formatter.ignoreMultilineInstructions = true;
        };
      };
      eslint.enable = true;
      helm_ls = {
        enable = true;
        config = {
          settings.helm-ls = {
            yamlls = {
              config = {
                kubernetesCRDStore.enable = true;
              };
            };
          };
        };
      };
      ltex = {
        enable = true;
        package = pkgs.ltex-ls-plus;
        config = {
          cmd = [ "ltex-ls-plus" ];
          filetypes = [
            "bib"
            "context"
            "gitcommit"
            "html"
            "markdown"
            "org"
            "pandoc"
            "plaintex"
            "quarto"
            "mail"
            "mdx"
            "rmd"
            "rnoweb"
            "rst"
            "tex"
            "text"
            "typst"
            "xhtml"
          ];
          settings.ltex = {
            language = "auto";
            enabled = [
              "bibtex"
              "context"
              "context.tex"
              "html"
              "latex"
              "markdown"
              "mdx"
              "typst"
              "asciidoc"
              "neorg"
              "org"
              "quarto"
              "restructuredtext"
              "rsweave"
            ];
            additionalRules.motherTongue = lib.mkDefault "fr-FR";
            ltex-ls.path = "${config.lsp.servers.ltex.package}";
          };
        };
      };
      lua_ls.enable = true;
      nixd = {
        enable = true;
        config.settings.nixd = {
          formatting.command = [
            "${lib.getExe pkgs.nixfmt}"
            "--width=80"
          ];
          options = {
            nixos.expr = ''(builtins.getFlake "${self.outPath}").lspHints.nixos or {}'';
            homeManager.expr = ''(builtins.getFlake "${self.outPath}").lspHints.homeManager or {}'';
            nixvim.expr = ''
              (builtins.getFlake "${self.outPath}").packages.${pkgs.stdenv.hostPlatform.system}.nvim-cirno.options or {}
            '';
          };
        };
      };
      jsonls.enable = true;
      terraformls.enable = true;
      texlab.enable = true;
      tinymist = {
        enable = true;
        config.settings = {
          formatterMode = "typstyle";
          formatterPrintWidth = 80;
        };
      };
      qmlls.enable = true;
      vala_ls.enable = true;
      vhdl_ls.enable = true;
      yamlls = {
        enable = true;
        config.settings = {
          yaml = {
            schemas = {
              kubernetes = "templates/**";
            };
            completion = true;
            hover = true;
            schemaStore.enable = true;
            kubernetesCRDStore.enable = true;
          };
        };
      };
      rust_analyzer = {
        enable = true;
      };
    };
  };
}
