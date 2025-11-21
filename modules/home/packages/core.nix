# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, pkgs, ... }:

{
  options = {
    tsrk.packages.core = {
      enable = lib.options.mkEnableOption "tsrk's core user packages bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.core.enable {
    programs = {
      btop.enable = true;
      ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
      };
      fd.enable = true;
      nh.enable = lib.mkDefault true;
    };

    home.packages = with pkgs; [ tldr ];

    services.tldr-update.enable = true;
  };
}
