{ pkgsUnstable, ... }:

let
  gdbProgram = ''
    function()
      local path = vim.fn.input({
          prompt = 'Path to executable: ',
          default = vim.fn.getcwd() .. '/',
          completion = 'file',
      })

      return (path and path ~= "") and path or require("dap").ABORT
    end
  '';
in
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      adapters.executables = {
        gdb = {
          id = "gdb";
          command = "${pkgsUnstable.gdb}/bin/gdb";
          args = [ "--quiet" "--interpreter=dap" ];
        };
      };
      configurations = rec {
        c = [
          {
            name = "Run executable (GDB)";
            type = "gdb";
            request = "launch";
            program.__raw = gdbProgram;
          }
          {
            name = "Run executable with arguments (GDB)";
            type = "gdb";
            request = "launch";
            program.__raw = gdbProgram;
            args.__raw = ''
              function()
                local args_str = vim.fn.input({
                    prompt = 'Arguments: ',
                })
                return vim.split(args_str, ' +')
              end
            '';
          }
          {
            name = "Attach to process (GDB)";
            type = "gdb";
            request = "attach";
            processId.__raw = "require('dap.utils').pick_process";
          }
        ];
        cc = c;
        cpp = c;
      };
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
        layouts = [
          {
            elements = [
              { id = "scopes"; size = 0.33; }
              { id = "breakpoints"; size = 0.17; }
              { id = "stacks"; size = 0.25; }
              { id = "watches"; size = 0.25; }
            ];
            size = 10;
            position = "right";
          }
          {
            elements = [
              { id = "repl"; size = 0.45; }
              { id = "console"; size = 0.55; }
            ];
            size = 10;
            position = "bottom";
          }
        ];
        floating = {
          border = "rounded";
          maxHeight = 0.9;
          maxWidth = 0.5;
        };
        render = {
          indent = 1;
          maxValueLines = 100;
        };
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
