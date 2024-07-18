{ lib, config, ... }:

{
  options = {
    tsrk.shell.zoxide = {
      enable = lib.options.mkEnableOption "tsrk's zoxide shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.zoxide.enable {

    home.shellAliases = {
      cd = "z";
    };

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
