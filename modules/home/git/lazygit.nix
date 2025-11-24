# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, pkgs, ... }:

let tsrkPkgs = self.packages.${pkgs.system};
in {
  options = {
    tsrk.git.lazygit.enable =
      lib.options.mkEnableOption "tsrk's Lazygit configuration";
  };

  config = lib.mkIf config.tsrk.git.lazygit.enable {

    home.shellAliases = { lg = "lazygit"; };

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "${pkgs.delta}/bin/delta --dark --paging=never";
          };
          showIcons = true;
          commit.signOff = true;
        };

        customCommands = [{
          key = "S";
          command = "git push {{.Form.TagArg}}";
          context = "localBranches";
          description = "Submit (push tags)";
          loadingText = "Pushing tags...";
          prompts = [{
            type = "menu";
            title = "Push tags";
            key = "TagArg";
            options = [
              {
                name = "tag_only";
                description = "Push tags only";
                value = "--tags";
              }
              {
                name = "follow_tags";
                description = "Push tags and commits";
                value = "--follow-tags";
              }
            ];
          }];
        }];
      };
    };

    specialisation = {
      light.configuration = {
        programs.lazygit.settings = self.lib.fromYAML pkgs (builtins.readFile
          "${tsrkPkgs.tokyonight-extras}/lazygit/tokyonight_day.yml");
      };
      dark.configuration = {
        programs.lazygit.settings = self.lib.fromYAML pkgs (builtins.readFile
          "${tsrkPkgs.tokyonight-extras}/lazygit/tokyonight_storm.yml");
      };
    };
  };
}
