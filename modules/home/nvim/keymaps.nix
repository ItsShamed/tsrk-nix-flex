{ lib, ... }:

let
  keymap = action: desc: mode: {
    inherit action;
    inherit mode;
    options = {
      inherit desc;
      noremap = true;
      silent = true;
    };
  };

  keymapLua = action: desc: mode: {
    inherit action;
    inherit mode;
    options = {
      inherit desc;
      noremap = true;
      silent = true;
    };
    lua = true;
  };

  keymapNoD = action: mode: keymap action null mode;
  keymapLuaNoD = action: mode: keymapLua action null mode;

  newSettingsConvert = attr:
    lib.lists.flatten
      (builtins.map
        (val: lib.attrsets.attrValues (lib.attrsets.mapAttrs (key: opts: opts // { inherit key; }) val))
        (lib.attrsets.attrValues attr));
in
{
  programs.nixvim = {
    globals.mapleader = " ";

    keymaps = newSettingsConvert {
      normalVisualOp = {
        "<Space>" = keymapNoD "<Nop>" "";
      };

      normal = {
        # Window nav
        "<C-h>" = keymapNoD "<C-w>h" "n";
        "<C-j>" = keymapNoD "<C-w>j" "n";
        "<C-k>" = keymapNoD "<C-w>k" "n";
        "<C-l>" = keymapNoD "<C-w>l" "n";

        # Window resize
        "<C-Up>" = keymapNoD ":resize -2<CR>" "n";
        "<C-Down>" = keymapNoD ":resize +2<CR>" "n";
        "<C-Left>" = keymapNoD ":vertical resize -2<CR>" "n";
        "<C-Right>" = keymapNoD ":vertical resize +2<CR>" "n";

        # Buffers / tab
        "<S-l>" = keymapNoD ":bnext<CR>" "n";
        "<S-h>" = keymapNoD ":bprevious<CR>" "n";

        # Move current line like VSCode
        "<A-j>" = keymapNoD ":m .+1<CR>==" "n";
        "<A-k>" = keymapNoD ":m .-2<CR>==" "n";

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
        "<leader>e" = keymap ":NvimTreeToggle<CR>" "Show file explorer" "n";
      };

      insert = {
        "jk" = keymapNoD "<ESC>" "i";

        # Move current line like VSCode
        "<A-j>" = keymapNoD "<Esc>:m .+1<CR>==gi" "i";
        "<A-k>" = keymapNoD "<Esc>:m .-2<CR>==gi" "i";
      };

      visual = {
        "<" = keymapNoD "<gv" "v";
        ">" = keymapNoD ">gv" "v";
      };

      visualOnly = {
        "<A-j>" = keymapNoD ":m '>+1<CR>gv-gv" "x";
        "<A-k>" = keymapNoD ":m '<-2<CR>gv-gv" "x";
        "<S-j>" = keymapNoD ":m '>+1<CR>gv-gv" "x";
        "<S-k>" = keymapNoD ":m '<-2<CR>gv-gv" "x";
      };
    };
  };
}
