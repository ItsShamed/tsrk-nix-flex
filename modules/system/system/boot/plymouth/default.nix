# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.boot.plymouth = {
      enable = lib.options.mkEnableOption "tsrk's Plymouth configuration";
    };
  };

  config = lib.mkIf config.tsrk.boot.plymouth.enable {
    boot.plymouth = {
      enable = lib.mkDefault true;
      theme = "breeze";
      logo = lib.mkDefault ./fumo.png;
    };
  };
}
