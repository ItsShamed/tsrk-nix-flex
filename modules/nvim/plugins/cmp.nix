{ lib, helpers, ... }:

let
  icons = import ../utils/icons.nix;

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

  # Migrates the obsoleted mapping syntax to the raw one
  # Basically https://github.com/nix-community/nixvim/blob/nixos-23.11/plugins/completion/nvim-cmp/default.nix#L502C19-L535C33
  # Idk why they changed that for 24.05, it used to work well like it was
  migrateMappings = with lib; mapping:
    let
      mappings =
        helpers.ifNonNull' mapping
          (mapAttrs
            (
              key: action:
                helpers.mkRaw (
                  if isString action
                  then action
                  else
                    let
                      modes = if action ? modes then action.modes else null;
                      modesString =
                        optionalString
                          (
                            (modes != null)
                            && ((length modes) >= 1)
                          )
                          ("," + (helpers.toLuaObject modes));
                    in
                    "cmp.mapping(${action.action}${modesString})"
                )
            )
            mapping);

      luaMappings = helpers.toLuaObject mappings;

      wrapped =
        lists.fold
          (
            presetName: prevString: ''cmp.mapping.preset.${presetName}(${prevString})''
          )
          luaMappings
          [ ];
    in
    helpers.mkRaw wrapped;
in
{
  plugins.cmp.enable = true;
  plugins.cmp.settings.mapping = migrateMappings {
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

  plugins.cmp.settings.sources = [
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

  plugins.cmp.settings.snippet.expand =
    "function(args) require('luasnip').lsp_expand(args.body) end";
  plugins.cmp.settings.formatting.format = ''
    function(entry, vim_item)
      local icons = ${helpers.toLuaObject icons}
      local kind_icons = icons.kind
      local source_names = ${helpers.toLuaObject sourceNames}
      local duplicates = ${helpers.toLuaObject duplicates}

      local max_width = 0
      if max_width ~= 0 and #vim_item.abbr > max_width then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
      end
      vim_item.kind = kind_icons[vim_item.kind]

      if entry.source.name == "crate" then
        vim_item.kind = icons.misc.Package
        vim_item.kind_hl_group = "CmpItemKindCrate"
      end

      if entry.source.name == "lab.quick_data" then
        vim_item.kind = icons.misc.CircuitBoard
        vim_item.kind_hl_group = "CmpItemKindConstant"
      end

      if entry.source.name == "emoji" then
        vim_item.kind = icons.misc.Smiley
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
}
