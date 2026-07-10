# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
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
    tsrk.git.lazygit.enable = lib.options.mkEnableOption "tsrk's Lazygit configuration";
  };

  config = lib.mkIf config.tsrk.git.lazygit.enable {

    home.shellAliases = {
      lg = "lazygit";
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          pagers = [
            {
              colorArg = "always";
              pager = "${pkgs.delta}/bin/delta --dark --paging=never";
            }
          ];
          overrideGpg = true;
          showIcons = true;
          commit.signOff = true;
        };

        customCommands = [
          {
            key = "S";
            command = "git push {{.Form.TagArg}}";
            context = "localBranches";
            description = "Submit (push tags)";
            loadingText = "Pushing tags...";
            prompts = [
              {
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
              }
            ];
          }
        ];
        gui = {
          nerdFontsVersion = "3";
        };
      };
    };

    specialisation = {
      light.configuration = {
        # Taken from
        # https://github.com/folke/tokyonight.nvim/blob/main/extras/lazygit/tokyonight_day.yml
        programs.lazygit.settings.gui.theme = rec {
          activeBorderColour = [
            "#b15c00"
            "bold"
          ];
          inactiveBorderColour = [ "#4094a3" ];
          searchingActiveBorderColor = activeBorderColour;
          optionsTextColor = [ "#2e7de9" ];
          selectedLineBgColor = [ "#b7c1e3" ];
          cherryPickedCommitFgColor = optionsTextColor;
          cherryPickedCommitBgColor = [ "#9854f1" ];
          markedBaseCommitFgColor = optionsTextColor;
          markedBaseCommitBgColor = [ "#8c6c3e" ];
          unstagedChangesColor = [ "#c64343" ];
          defaultFgColor = [ "#3760bf" ];
        };
      };
      dark.configuration = {
        # Taken from
        # https://github.com/folke/tokyonight.nvim/blob/main/extras/lazygit/tokyonight_storm.yml
        programs.lazygit.settings.gui.theme = rec {
          activeBorderColour = [
            "#ff9e64"
            "bold"
          ];
          inactiveBorderColour = [ "#29a4bd" ];
          searchingActiveBorderColor = activeBorderColour;
          optionsTextColor = [ "#7aa2f7" ];
          selectedLineBgColor = [ "#2e3c64" ];
          cherryPickedCommitFgColor = optionsTextColor;
          cherryPickedCommitBgColor = [ "#bb9af7" ];
          markedBaseCommitFgColor = optionsTextColor;
          markedBaseCommitBgColor = [ "#e0af68" ];
          unstagedChangesColor = [ "#db4b4b" ];
          defaultFgColor = [ "#c0caf5" ];
        };
      };
    };
  };
}
