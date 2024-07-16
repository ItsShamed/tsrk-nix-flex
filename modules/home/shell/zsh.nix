{ lib, config, ... }:

{
  options = {
    tsrk.shell.zsh = {
      enable = lib.options.mkEnableOption "tsrk's zsh configuration";
    };
  };

  config = lib.mkIf config.tsrk.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      autocd = true;
    };
  };
}
