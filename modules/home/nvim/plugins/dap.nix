{ config, lib, vimHelpers, pkgs, ... }:

{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DiagnosticSignError";
          linehl = "";
          numhl = "";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DiagnosticSignError";
          linehl = "";
          numhl = "";
        };
        dapStopped = {
          text = "";
          texthl = "DiagnosticSignError";
          linehl = "";
          numhl = "";
        };
      };
      extensions.dap-ui = {
        enable = true;
#        layouts = [
#          {
#            elements = [
#              { id = "scopes"; size = 0.33; }
#              { id = "breakpoints"; size = 0.17; }
#              { id = "stacks"; size = 0.25; }
#              { id = "watches"; size = 0.25; }
#            ];
#            size = 0.33;
#            position = "right";
#          }
#          {
#            elements = [
#              { id = "repl"; size = 0.45; }
#              { id = "console"; size = 0.55; }
#            ];
#            size = 0.27;
#            position = "bottom";
#          }
#        ];
#        floating = {
#          border = "rounded";
#          maxHeight = 0.9;
#          maxWidth = 0.5;
#        };
#        render = {
#          indent = 1;
#          maxValueLines = 100;
#        };
#      };
    };
    };

    extraConfigLuaPost = ''
      -- DAP Post config
      local dap = require("dap")
      local dapui = require("dapui")

      dap.set_log_level("info")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    '';
  };
}
