{ config, lib, ... }:

{
  options = {
    tsrk.shell.bat = {
      enable = lib.options.mkEnableOption "tsrk's bat configuration";
      themes = {
        light = lib.options.mkOption {
          type = lib.types.str;
          description = "Light theme name";
          default = "OneHalfLight";
        };
        dark = lib.options.mkOption {
          type = lib.types.str;
          description = "Dark theme name";
          default = "OneHalfDark";
        };
      };
    };
  };
  config = lib.mkIf config.tsrk.shell.bat.enable {
    programs.bat = {
      enable = true;
    };

    specialisation = {
      light.configuration = {
        programs.bat.config.theme = config.tsrk.shell.bat.themes.light;
      };
      dark.configuration = {
        programs.bat.config.theme = config.tsrk.shell.bat.themes.dark;
      };
    };
  };
}
