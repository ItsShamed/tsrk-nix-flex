{ pkgs, lib, config, ... }:

let
  cfg = config.tsrk.git.delta;

  delta-repo = pkgs.fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "fdfcc8fce30754a4f05eeb167a15d519888fc909";
    hash = "sha256-lj/HVcO0gDCdGLy0xm+m9SH4NM+BT3Jar6Mv2sKNZpQ=";
  };
in
{
  options = {
    tsrk.git.delta = {
      enable = lib.options.mkEnableOption "delta";
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

  config = lib.mkIf config.tsrk.git.delta.enable {
    programs.git.delta.enable = true;
    programs.git.includes = [{ path = "${delta-repo}/themes.gitconfig"; }];

    specialisation = {
      light.configuration = {
        programs.git.delta.options.syntax-theme = cfg.themes.light;
      };
      dark.configuration = {
        programs.git.delta.options.syntax-theme = cfg.themes.dark;
      };
    };
  };
}
