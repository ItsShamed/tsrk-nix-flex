# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, ... }:

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
in {
  plugins = {
    dap = {
      enable = true;
      adapters.executables = {
        gdb = {
          id = "gdb";
          command = "${pkgs.gdb}/bin/gdb";
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
    };

    dap-ui = {
      luaConfig.post = ''
        -- DAP Post config
        local dap = require("dap")
        local dapui = require("dapui")

        dap.set_log_level("info")

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
      '';
      enable = true;
      settings = {
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.33;
              }
              {
                id = "breakpoints";
                size = 0.17;
              }
              {
                id = "stacks";
                size = 0.25;
              }
              {
                id = "watches";
                size = 0.25;
              }
            ];
            size = 10;
            position = "right";
          }
          {
            elements = [
              {
                id = "repl";
                size = 0.45;
              }
              {
                id = "console";
                size = 0.55;
              }
            ];
            size = 10;
            position = "bottom";
          }
        ];
        floating = {
          border = "rounded";
          max_height = 0.9;
          max_width = 0.5;
        };
        render = {
          indent = 1;
          max_value_lines = 100;
        };
      };
    };
  };
}
