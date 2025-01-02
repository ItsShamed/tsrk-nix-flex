# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

let cfg = config.tsrk.shell.direnv;
in {
  options = {
    tsrk.shell.direnv = {
      enable = lib.options.mkEnableOption "tsrk's direnv configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      nix-direnv.enable = true;
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
