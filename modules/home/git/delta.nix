# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  pkgs,
  lib,
  config,
  ...
}:

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.tsrk.git.delta;
in
{
  options = {
    tsrk.git.delta = {
      enable = lib.options.mkEnableOption "delta";
      themes = {
        light = lib.options.mkOption {
          type = lib.types.str;
          description = "Light theme name";
          default = "TokyoNight Day";
        };
        dark = lib.options.mkOption {
          type = lib.types.str;
          description = "Dark theme name";
          default = "TokyoNight Storm";
        };
      };
    };
  };

  config = lib.mkIf config.tsrk.git.delta.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    # Setting low-prio config in case the bat module is not imported
    # In which case will be enventually overriden if it is imported
    programs.bat = {
      enable = lib.mkDefault true;
      themes."TokyoNight" = lib.mkDefault {
        src = tsrkPkgs.tokyonight-extras;
        file = "sublime/tokyonight_night.tmTheme";
      };
    };

    specialisation = {
      light.configuration = {
        programs.git.includes = [
          {
            path = "${tsrkPkgs.tokyonight-extras}/delta/tokyonight_day.gitconfig";
          }
        ];
        programs.git.delta.options.syntax-theme = cfg.themes.light;
      };
      dark.configuration = {
        programs.git.includes = [
          {
            path = "${tsrkPkgs.tokyonight-extras}/delta/tokyonight_storm.gitconfig";
          }
        ];
        programs.git.delta.options.syntax-theme = cfg.themes.dark;
      };
    };
  };
}
