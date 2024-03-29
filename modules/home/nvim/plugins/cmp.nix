{ config, lib, pkgs, vimHelpers, ... }:

with vimHelpers;
let
  icons = {
    Array = "";
    Boolean = "";
    Class = "";
    Color = "";
    Constant = "";
    Constructor = "";
    Enum = "";
    EnumMember = "";
    Event = "";
    Field = "";
    File = "";
    Folder = "󰉋";
    Function = "";
    Interface = "";
    Key = "";
    Keyword = "";
    Method = "";
    Module = "";
    Namespace = "";
    Null = "󰟢";
    Number = "";
    Object = "";
    Operator = "";
    Package = "";
    Property = "";
    Reference = "";
    Snippet = "";
    String = "";
    Struct = "";
    Text = "";
    TypeParameter = "";
    Unit = "";
    Value = "";
    Variable = "";
  };

  sourceNames = {
    nvim_lsp = "(LSP)";
    nvim_lsp_document_symbols = "(LSP)";
    emoji = "(Emoji)";
    path = "(Path)";
    calc = "(Calc)";
    luasnip = "(Snippet)";
    buffer = "(Buffer)";
    tmux = "(TMUX)";
    treesitter = "(TreeSitter)";
  };

  duplicates = {
    buffer = 1;
    path = 1;
    nvim_lsp = 0;
    luasnip = 1;
  };

  plugin = programs.nixvim.plugin.nvim-cmp;
in
{
  programs.nixvim = {
    plugins.nvim-cmp.enable = true;
    plugins.nvim-cmp.mapping = {
      "<CR>" = {
        action = ''
          function(fallback)
            local cmp_types = require("cmp.types.cmp")
            local ConfirmBehavior = cmp_types.ConfirmBehavior
            if cmp.visible() then
              local confirm_opts = { behavior = ConfirmBehavior.Replace, select = false }
              local is_insert_mode = function()
                return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
              end
              if is_insert_mode() then -- prevent overwriting brackets
                confirm_opts.behavior = ConfirmBehavior.Insert
              end
              local entry = cmp.get_selected_entry()
              if cmp.confirm(confirm_opts) then
                return -- success, exit early
              end
            end
            fallback()
          end
        '';
      };
      "<C-k>" = {
        action = "cmp.mapping.select_prev_item()";
        modes = [ "i" "c" ];
      };
      "<C-j>" = {
        action = "cmp.mapping.select_next_item()";
        modes = [ "i" "c" ];
      };
      "<Tab>" = {
        action = ''
          function(fallback)
            local luasnip = require("luasnip")

            local has_words_before = function()
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            local check_backspace = function()
              return not has_words_before()
            end

            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end
        '';
        modes = [ "i" "s" ];
      };
      "<S-Tab>" = {
        action = ''
          function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end
        '';
        modes = [ "i" "s" ];
      };
      "<C-Space>" = "cmp.mapping.complete()";
    };

    plugins.nvim-cmp.sources = [
      {
        name = "nvim_lsp";
        # entryFilter = ''
        #   function(entry, ctx)
        #     local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
        #     if kind == "Snippet" and ctx.prev_context.filetype == "java" then
        #       return false
        #     end
        #     return true
        #   end
        # '';
      }

      { name = "path"; }
      { name = "luasnip"; }
      { name = "buffer"; }
      { name = "nvim_lua"; }
      { name = "calc"; }
      { name = "treesitter"; }
      { name = "nvim_lsp_document_symbols"; }
    ];

    plugins.nvim-cmp.snippet.expand = "luasnip";
    plugins.nvim-cmp.formatting.format = ''
      function(entry, vim_item)
        local kind_icons = ${toLuaObject icons}
        local source_names = ${toLuaObject sourceNames}
        local duplicates = ${toLuaObject duplicates}

        local max_width = 0
        if max_width ~= 0 and #vim_item.abbr > max_width then
          vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. 
        end
        vim_item.kind = kind_icons[vim_item.kind]

        if entry.source.name == "emoji" then
          vim_item.kind = 
          vim_item.kind_hl_group = "CmpItemKindEmoji"
        end
        vim_item.menu = source_names[entry.source.name] or "(" .. entry.source.name .. ")"
        vim_item.dup = duplicates[entry.source.name] or 0
        return vim_item
      end
    '';

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-nvim-lsp-document-symbol.enable = true;
    plugins.cmp-zsh.enable = true;
    plugins.cmp-treesitter.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp_luasnip.enable = true;
    plugins.cmp-calc.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-nvim-lua.enable = true;
  };
}
