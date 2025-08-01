# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, pkgs, ... }:

{
  options = { tsrk.flameshot.enable = lib.options.mkEnableOption "flameshot"; };

  config = lib.mkIf config.tsrk.flameshot.enable {
    services.flameshot = {
      enable = lib.mkDefault true;
      package = pkgs.flameshot.override { enableWlrSupport = true; };
      settings.General.useJpgForClipboard = true;
    };
  };
}
