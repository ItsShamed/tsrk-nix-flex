# # Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    tsrk.packages.compat = {
      enable = lib.options.mkEnableOption "tsrk's compat tools bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.compat.enable {
    home.packages = with pkgs; [
      distrobox
      distrobox-tui
      boxbuddy
    ];
  };
}
