{ config, lib, pkgs, ... }:

let
  keymap = action: desc: {
    inherit action desc;
    silent = true;
  };

  keymapLua = action: desc: {
    inherit action desc;
    silent = true;
    lua = true;
  };

  keymapNoD = action: keymap action null;
  keymapLuaNoD = action: keymapLua action null;
in
{
  programs.nixvim = {
    globals.mapleader = " ";

    maps = {
      normalVisualOp = {
        "<Space>" = keymapNoD "<Nop>";
      };

      normal = {
        # Window nav
        "<C-h>" = keymapNoD "<C-w>h";
        "<C-j>" = keymapNoD "<C-w>j";
        "<C-k>" = keymapNoD "<C-w>k";
        "<C-l>" = keymapNoD "<C-w>l";

        # Window resize
        "<C-Up>" = keymapNoD ":resize -2<CR>";
        "<C-Down>" = keymapNoD ":resize +2<CR>";
        "<C-Left>" = keymapNoD ":vertical resize -2<CR>";
        "<C-Right>" = keymapNoD ":vertical resize +2<CR>";

        # Buffers / tab
        "<S-l>" = keymapNoD ":bnext<CR>";
        "<S-h>" = keymapNoD ":bprevious<CR>";

        # Move current line like VSCode
        "<A-j>" = ":m .+1<CR>==";
        "<A-k>" = ":m .-2<CR>==";

        # "<leader>h" = keymap "<cmd>nohlsearch<CR>" "Clear highlights";
        # "<leader>w" = keymap "<cmd>w!<CR>" "Save";
        # "<leader>q" = keymap "<cmd>confirm q<CR>" "Quit";
        # "<leader>/" = keymap "<Plug>(comment_toggle_linewise_current)" "Comment toggle current line";
        # "<leader>c" = keymap "<cmd>BufferKill<CR>" "Close buffer";
        # "<leader>f" = keymapLua ''
        #   function()
        #     find_project_files { previewer = flase }
        #   end
        # '' "Find files";
      };

      insert = {
        "jk" = keymapNoD "<ESC>";

        # Move current line like VSCode
        "<A-j>" = keymapNoD "<Esc>:m .+1<CR>==gi";
        "<A-k>" = keymapNoD "<Esc>:m .-2<CR>==gi";
      };

      visual = {
        "<" = keymapNoD "<gv";
        ">" = keymapNoD ">gv";
      };

      visualOnly = {
        "<A-j>" = keymapNoD ":m '>+1<CR>gv-gv";
        "<A-k>" = keymapNoD ":m '<-2<CR>gv-gv";
        "<S-j>" = keymapNoD ":m '>+1<CR>gv-gv";
        "<S-k>" = keymapNoD ":m '<-2<CR>gv-gv";
      };
    };
  };
}
