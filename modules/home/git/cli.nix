# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, pkgs, lib, ... }:

{
  options = {
    tsrk.git.cli = {
      enable = lib.options.mkEnableOption "tsrk's Git CLI utils bundle";
    };
  };

  config = lib.mkIf config.tsrk.git.cli.enable {
    programs.gh-dash.enable = lib.mkDefault true;
    programs.gh = {
      enable = lib.mkDefault true;
      extensions = [
        # TODO
      ];
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
    home.packages = with pkgs; [ glab ];
  };
}
