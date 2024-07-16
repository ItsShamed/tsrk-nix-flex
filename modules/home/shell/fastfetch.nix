{ lib, config, ... }:

{
  options = {
    tsrk.shell.fastfetch = {
      enable = lib.options.mkEnableOption "tsrk's Fastfetch shell integration";
    };
  };

  config = lib.mkIf config.tsrk.shell.fastfetch.enable {

    tsrk.shell.initExtra = ''
      ${config.programs.fastfetch.package}/bin/fastfetch
    '';

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${./files/cirnix.png}";
          width = 100;
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "packages"
          "wm"
          "terminal"
          "display"
          "cpu"
          "gpu"
          "break"
          "break"
          "colors"
        ];
      };
    };
  };
}
