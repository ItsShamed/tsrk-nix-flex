# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }:

with lib.nixvim;
let

  lua = code: { __raw = code; };

  mappingsOptions = {
    mode = "n";
    prefix = "<leader>";
    buffer = null;
    silent = true;
    noremap = true;
    nowait = true;
  };

  visualMappingsOptions = {
    mode = "v";
    prefix = "<leader>";
    buffer = null;
    silent = true;
    noremap = true;
    nowait = true;
  };

  mkConvertedSpec =
    options: attrs:
    let
      filteredAttrs = [
        "prefix"
        "buffer"
        "noremap"
        "silent"
      ];

      checkAttrValid = n: builtins.all (s: s != n) filteredAttrs;
      filteredOptions = lib.attrsets.filterAttrs (n: _: checkAttrValid n) options;

      mkConvertedMap =
        keys: mapping: options:
        assert (builtins.length mapping) >= 1;
        {
          __unkeyed-1 = keys;
          __unkeyed-2 = builtins.elemAt mapping 0;
          remap = !(options.noremap or true);
        }
        // filteredOptions
        // (
          if (builtins.length mapping) > 1 then
            {
              desc = builtins.elemAt mapping 1;
            }
          else
            { }
        );

      convertMappingChild =
        prefix: obj:
        if builtins.isList obj then
          mkConvertedMap prefix obj options
        else if builtins.isAttrs obj then
          (lib.lists.flatten (
            convertMappingNode prefix (
              lib.attrsets.filterAttrs (n: _: n != "name") # avoid 'name' being treated as a keybind
                obj
            )
          ))
          ++ (lib.lists.optional (builtins.hasAttr "name" obj) (
            {
              group = obj.name;
              __unkeyed-1 = prefix;
            }
            // filteredOptions
          ))
        else
          builtins.throw "child should either be an attrset (group) or a list (mapping).";

      convertMappingNode =
        prefix: attrs:
        lib.lists.flatten (
          lib.attrsets.mapAttrsToList (
            key: mapping:
            builtins.addErrorContext
              "while converting which-key `${prefix + key}` mapping node to new spec"
              (convertMappingChild (prefix + key) mapping)
          ) attrs
        );
    in
    builtins.addErrorContext "while converting which-key mapping to new spec" (
      lib.lists.flatten (convertMappingNode (options.prefix) attrs)
    );

  visualMappings = mkConvertedSpec visualMappingsOptions {
    "/" = [
      "<Plug>(comment_toggle_linewise_visual)"
      "Comment toggle (visual)"
    ];
    l = {
      name = "LSP";
      a = [
        "<cmd>lua vim.lsp.buf.code_action()<cr>"
        "Code action"
      ];
    };
  };

  mappings = mkConvertedSpec mappingsOptions {
    ";" = [
      "<cmd>Alpha<CR>"
      "Dashboard"
    ];
    "a" = [
      "<cmd>w!<CR>"
      "Save"
    ];
    "q" = [
      "<cmd>confirm q<CR>"
      "Quit"
    ];
    "/" = [
      "<Plug>(comment_toggle_linewise_current)"
      "Comment toggle current line"
    ];
    "c" = [
      "<cmd>bd<CR>"
      "Close Buffer"
    ];
    "f" = [
      (lua ''
        function()
          find_project_files { previewer = false }
        end
      '')
      "Find File"
    ];
    "h" = [
      "<cmd>nohlsearch<CR>"
      "Clear highlights"
    ];
    "e" = [
      "<cmd>NvimTreeToggle<CR>"
      "Explorer"
    ];

    b = {
      name = "Buffers";
      j = [
        "<cmd>BufferLinePick<cr>"
        "Jump"
      ];
      f = [
        "<cmd>Telescope buffers previewer=false<cr>"
        "Find"
      ];
      b = [
        "<cmd>BufferLineCyclePrev<cr>"
        "Previous"
      ];
      n = [
        "<cmd>BufferLineCycleNext<cr>"
        "Next"
      ];
      W = [
        "<cmd>noautocmd w<cr>"
        "Save without formatting (noautocmd)"
      ];
      e = [
        "<cmd>BufferLinePickClose<cr>"
        "Pick which buffer to close"
      ];
      h = [
        "<cmd>BufferLineCloseLeft<cr>"
        "Close all to the left"
      ];
      l = [
        "<cmd>BufferLineCloseRight<cr>"
        "Close all to the right"
      ];
      D = [
        "<cmd>BufferLineSortByDirectory<cr>"
        "Sort by directory"
      ];
      L = [
        "<cmd>BufferLineSortByExtension<cr>"
        "Sort by language"
      ];
      "c" = [
        "<cmd>bd<CR>"
        "Close Buffer"
      ];
    };

    d = {
      name = "Debug";
      t = [
        "<cmd>lua require'dap'.toggle_breakpoint()<cr>"
        "Toggle Breakpoint"
      ];
      b = [
        "<cmd>lua require'dap'.step_back()<cr>"
        "Step Back"
      ];
      c = [
        "<cmd>lua require'dap'.continue()<cr>"
        "Continue"
      ];
      C = [
        "<cmd>lua require'dap'.run_to_cursor()<cr>"
        "Run To Cursor"
      ];
      d = [
        "<cmd>lua require'dap'.disconnect()<cr>"
        "Disconnect"
      ];
      g = [
        "<cmd>lua require'dap'.session()<cr>"
        "Get Session"
      ];
      i = [
        "<cmd>lua require'dap'.step_into()<cr>"
        "Step Into"
      ];
      o = [
        "<cmd>lua require'dap'.step_over()<cr>"
        "Step Over"
      ];
      u = [
        "<cmd>lua require'dap'.step_out()<cr>"
        "Step Out"
      ];
      p = [
        "<cmd>lua require'dap'.pause()<cr>"
        "Pause"
      ];
      r = [
        "<cmd>lua require'dap'.repl.toggle()<cr>"
        "Toggle Repl"
      ];
      s = [
        "<cmd>lua require'dap'.continue()<cr>"
        "Start"
      ];
      q = [
        "<cmd>lua require'dap'.close()<cr>"
        "Quit"
      ];
      U = [
        "<cmd>lua require'dapui'.toggle({reset = true})<cr>"
        "Toggle UI"
      ];
    };

    l = {
      name = "LSP";
      a = [
        "<cmd>lua vim.lsp.buf.code_action()<cr>"
        "Code Action"
      ];
      d = [
        "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>"
        "Buffer Diagnostics"
      ];
      w = [
        "<cmd>Telescope diagnostics<cr>"
        "Diagnostics"
      ];
      f = [
        "<cmd>lua format()<cr>"
        "Format"
      ];
      i = [
        "<cmd>LspInfo<cr>"
        "Info"
      ];
      j = [
        "<cmd>lua vim.diagnostic.goto_next()<cr>"
        "Next Diagnostic"
      ];
      k = [
        "<cmd>lua vim.diagnostic.goto_prev()<cr>"
        "Prev Diagnostic"
      ];
      l = [
        "<cmd>lua vim.lsp.codelens.run()<cr>"
        "CodeLens Action"
      ];
      q = [
        "<cmd>lua vim.diagnostic.setloclist()<cr>"
        "Quickfix"
      ];
      r = [
        "<cmd>lua vim.lsp.buf.rename()<cr>"
        "Rename"
      ];
      s = [
        "<cmd>Telescope lsp_document_symbols<cr>"
        "Document Symbols"
      ];
      S = [
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>"
        "Workspace Symbols"
      ];
      e = [
        "<cmd>Telescope quickfix<cr>"
        "Telescope Quickfix"
      ];
    };
    s = {
      name = "Search";
      b = [
        "<cmd>Telescope git_branches<cr>"
        "Checkout branch"
      ];
      c = [
        "<cmd>Telescope colorscheme<cr>"
        "Colorscheme"
      ];
      f = [
        "<cmd>Telescope find_files<cr>"
        "Find File"
      ];
      h = [
        "<cmd>Telescope help_tags<cr>"
        "Find Help"
      ];
      H = [
        "<cmd>Telescope highlights<cr>"
        "Find highlight groups"
      ];
      M = [
        "<cmd>Telescope man_pages<cr>"
        "Man Pages"
      ];
      r = [
        "<cmd>Telescope oldfiles<cr>"
        "Open Recent File"
      ];
      R = [
        "<cmd>Telescope registers<cr>"
        "Registers"
      ];
      t = [
        "<cmd>Telescope live_grep<cr>"
        "Text"
      ];
      k = [
        "<cmd>Telescope keymaps<cr>"
        "Keymaps"
      ];
      C = [
        "<cmd>Telescope commands<cr>"
        "Commands"
      ];
      l = [
        "<cmd>Telescope resume<cr>"
        "Resume last search"
      ];
      p = [
        "<cmd>lua require('telescope.builtin').colorscheme([enable_preview = true])<cr>"
        "Colorscheme with Preview"
      ];
    };
    g = {
      name = "Git";
      g = [
        "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>"
        "Lazygit"
      ];
      j = [
        "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>"
        "Next Hunk"
      ];
      k = [
        "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>"
        "Prev Hunk"
      ];
      l = [
        "<cmd>lua require 'gitsigns'.blame_line()<cr>"
        "Blame"
      ];
      L = [
        "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>"
        "Blame Line (full)"
      ];
      p = [
        "<cmd>lua require 'gitsigns'.preview_hunk()<cr>"
        "Preview Hunk"
      ];
      r = [
        "<cmd>lua require 'gitsigns'.reset_hunk()<cr>"
        "Reset Hunk"
      ];
      R = [
        "<cmd>lua require 'gitsigns'.reset_buffer()<cr>"
        "Reset Buffer"
      ];
      s = [
        "<cmd>lua require 'gitsigns'.stage_hunk()<cr>"
        "Stage Hunk"
      ];
      u = [
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>"
        "Undo Stage Hunk"
      ];
      o = [
        "<cmd>Telescope git_status<cr>"
        "Open changed file"
      ];
      b = [
        "<cmd>Telescope git_branches<cr>"
        "Checkout branch"
      ];
      c = [
        "<cmd>Telescope git_commits<cr>"
        "Checkout commit"
      ];
      C = [
        "<cmd>Telescope git_bcommits<cr>"
        "Checkout commit(for current file)"
      ];
      d = [
        "<cmd>Gitsigns diffthis HEAD<cr>"
        "Git Diff"
      ];
    };
  };

  resultingMappings = mappings ++ visualMappings;
in
{
  plugins.which-key = {
    enable = true;

    settings = {
      plugins = {
        marks = false;
        registers = false;

        presets = {
          g = false;
          z = false;
          motions = false;
          nav = false;
          operators = false;
          textObjects = false;
          windows = false;
        };
      };

      ignoreMissing = true;
      showHelp = true;
      showKeys = true;

      disable.filetypes = [ "TelescopePrompt" ];

      layout = {
        height = {
          min = 4;
          max = 25;
        };
        width = {
          min = 20;
          max = 50;
        };
      };

      win = {
        border = "single";
        padding = [
          2
          2
        ];
      };

      spec = resultingMappings;
    };
  };

  # extraConfigLuaPost = ''
  #   function format_filter(client)
  #     local filetype = vim.bo.filetype
  #     local n = require "null-ls"
  #     local s = require "null-ls.sources"
  #     local method = n.methods.FORMATTING
  #     local available_formatters = s.get_available(filetype, method)
  #
  #     if #available_formatters > 0 then
  #       return client.name == "null-ls"
  #     elseif client.supports_method "textDocument/formatting" then
  #       return true
  #     else
  #       return false
  #     end
  #   end
  #
  #   function format(opts)
  #     opts = opts or {}
  #     opts.filter = opts.filter or format_filter
  #
  #     return vim.lsp.buf.format(opts)
  #   end
  #   -- Which-key mappings
  #
  #   local which_key = require "which-key"
  #
  #   local wk_opts = ${toLuaObject mappingsOptions}
  #   local wk_vopts = ${toLuaObject visualMappingsOptions}
  #
  #   local wk_mappings = ${toLuaObject mappings}
  #   local wk_vmappings = ${toLuaObject visualMappings}
  #
  #   which_key.register(wk_mappings, wk_opts)
  #   which_key.register(wk_vmappings, wk_vopts)
  # '';
}
