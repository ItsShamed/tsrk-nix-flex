# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.shell.fastfetch = {
      enable = lib.options.mkEnableOption "tsrk's Fastfetch shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.fastfetch.enable {

    tsrk.shell.initExtra = ''
      ${config.programs.fastfetch.package}/bin/fastfetch
    '';

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${./files/cirnix.png}";
          width = 30;
          height = 12;
          type = lib.mkDefault "kitty-direct";
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "packages"
          "wm"
          "terminal"
          "display"
          "cpu"
          "gpu"
          "break"
          "break"
          "colors"
        ];
      };
    };
  };
}
