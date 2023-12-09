{ config, lib, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
        showIcons = true;
      };

      customCommands = [
        {
          key = "<c-t>";
          command = "git push {{.Form.TagArg}}";
          context = "global";
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
    };
  };

  home.shellAliases.lg = "lazygit";
  programs.zsh.shellAliases.lg = "lazygit";

}
