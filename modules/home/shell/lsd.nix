# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.shell.lsd = {
      enable = lib.options.mkEnableOption "tsrk's lsd shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.lsd.enable {
    home.shellAliases.l = "lsd -lah";

    programs.lsd.enable = true;
  };
}
