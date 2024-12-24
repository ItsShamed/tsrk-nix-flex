{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.shell.bat = {
      enable = lib.options.mkEnableOption "tsrk's bat configuration";
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
  config = lib.mkIf config.tsrk.shell.bat.enable {
    /* Because of how the theme is generated upstream (name being the same
       regardless of the variant), we cannot guarantee at this time that there
       will be no conflicts internally w.r.t bat. So we provide one theme at a
       time, depending on the specialisation.
    */
    programs.bat = {
      enable = true;
      themes = {
        "TokyoNight Day" = {
          src = pkgs.tokyonight-extras;
          file = "sublime/tokyonight_day.tmTheme";
        };
        "TokyoNight" = {
          src = pkgs.tokyonight-extras;
          file = "sublime/tokyonight_night.tmTheme";
        };
        "TokyoNight Storm" = {
          src = pkgs.tokyonight-extras;
          file = "sublime/tokyonight_storm.tmTheme";
        };
      };
    };

    home.shellAliases.cat = "bat";

    specialisation = {
      light.configuration = {
        programs.bat.config.theme = config.tsrk.shell.bat.themes.light;
        programs.bat.themes.tokyonight = {
          src = pkgs.tokyonight-extras;
          file = "sublime/tokyonight_day.tmTheme";
        };
      };
      dark.configuration = {
        programs.bat.config.theme = config.tsrk.shell.bat.themes.dark;
        programs.bat.themes.tokyonight = {
          src = pkgs.tokyonight-extras;
          file = "sublime/tokyonight_storm.tmTheme";
        };
      };
    };
  };
}
