# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.shell.pay-respects;
in
{
  options = {
    tsrk.shell.pay-respects = {
      enable = lib.options.mkEnableOption "pay-respects";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.pay-respects = {
      enable = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
    };
  };
}
