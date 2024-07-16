{ lib, config, ... }:

{
  options = {
    tsrk.shell.lsd = {
      enable = lib.options.mkEnableOption "tsrk's lsd shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.lsd.enable {
    home.shellAliases = {
      l = "lsd -lah";
    };

    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  };
}
