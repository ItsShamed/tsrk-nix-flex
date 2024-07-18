{ pkgs, lib, config, ... }:

let
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
          default = "TokyoNight";
        };
        dark = lib.options.mkOption {
          type = lib.types.str;
          description = "Dark theme name";
          default = "TokyoNight";
        };
      };
    };
  };

  config = lib.mkIf config.tsrk.git.delta.enable {
    programs.git.delta.enable = true;

    # Setting low-prio config in case the bat module is not imported
    # In which case will be enventually overriden if it is imported
    programs.bat = {
      enable = lib.mkDefault true;
      themes.tokyonight = lib.mkDefault {
        src = pkgs.tokyonight-extras;
        file = "sublime/tokyonight_night.tmTheme";
      };
    };

    specialisation = {
      light.configuration = {
        programs.git.includes = [{ path = "${pkgs.tokyonight-extras}/delta/tokyonight_day.gitconfig"; }];
        programs.git.delta.options.syntax-theme = cfg.themes.light;
      };
      dark.configuration = {
        programs.git.includes = [{ path = "${pkgs.tokyonight-extras}/delta/tokyonight_storm.gitconfig"; }];
        programs.git.delta.options.syntax-theme = cfg.themes.dark;
      };
    };
  };
}
