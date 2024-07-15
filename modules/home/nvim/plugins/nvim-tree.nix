{ ... }:

{
  programs.nixvim = {
    plugins.nvim-tree.enable = true;
    plugins.nvim-tree = {
      actions.openFile.quitOnOpen = true;
      renderer.indentMarkers.enable = true;
      onAttach.__raw = ''
        function(bufnr)
          local api = require "nvim-tree.api"

          local function start_telescope(telescope_mode)
            local node = require("nvim-tree.lib").get_node_at_cursor()
            local abspath = node.link_to or node.absolute_path
            local is_folder = node.open ~= nil
            local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
            require("telescope.builtin")[telescope_mode] {
              cwd = basedir,
            }
          end

          local function set_keymaps(mode, key, val)
            local opt = { noremap = true, silent = true }
            if type(val) == "table" then
              opt = val[2]
              val = val[1]
            end
            if val then
              vim.keymap.set(mode, key, val, opt)
            else
              pcall(vim.api.nvim_del_keymap, mode, key)
            end
          end

          local function telescope_find_files(_)
            start_telescope "find_files"
          end

          local function telescope_live_grep(_)
            start_telescope "live_grep"
          end

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          local useful_keys = {
            ["l"] = { api.node.open.edit, opts "Open" },
            ["o"] = { api.node.open.edit, opts "Open" },
            ["<CR>"] = { api.node.open.edit, opts "Open" },
            ["v"] = { api.node.open.vertical, opts "Open: Vertical Split" },
            ["h"] = { api.node.navigate.parent_close, opts "Close Directory" },
            ["C"] = { api.tree.change_root_to_node, opts "CD" },
            ["gtg"] = { telescope_live_grep, opts "Telescope Live Grep" },
            ["gtf"] = { telescope_find_files, opts "Telescope Find File" },
          }

          for k, v in pairs(useful_keys) do
            set_keymaps("n", k, v)
          end

        end
      '';
    };
  };
}
