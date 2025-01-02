# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.shell.zoxide = {
      enable = lib.options.mkEnableOption "tsrk's zoxide shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.zoxide.enable {

    home.shellAliases = { cd = "z"; };

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
