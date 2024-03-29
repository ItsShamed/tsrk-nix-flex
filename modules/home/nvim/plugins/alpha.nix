{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins.alpha = {
      enable = true;
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          opts = {
            hl = "Type";
            position = "center";
          };
          type = "text";
          val = [
            "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗  "
            "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║  "
            "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║  "
            "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║  "
            "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║  "
            "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  "
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              command = "<CMD>Telescope find_files<CR>";
              desc = "󰈞  Find file";
              shortcut = "f";
            }
            {
              command = "<CMD>ene!<CR>";
              desc = "  New file";
              shortcut = "n";
            }
            {
              command = "<CMD>Telescope projects<CR>";
              desc = "  Projects";
              shortcut = "p";
            }
            {
              command = "<CMD>Telescope oldfiles<CR>";
              desc = "  Recent Files";
              shortcut = "r";
            }
            {
              command = "<CMD>Telescope livegrep<CR>";
              desc = "󰊄  Find Text";
              shortcut = "t";
            }
            {
              command = ":qa<CR>";
              desc = "Quit Neovim";
              shortcut = "q";
            }
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          opts = {
            hl = "Keyword";
            position = "center";
          };
          type = "text";
          val = "Quoicoubeh.";
        }
      ];
    };
  };
}
