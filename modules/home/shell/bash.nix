{ lib, config, ... }:

{
  options = {
    tsrk.shell.bash = {
      enable = lib.options.mkEnableOption "tsrk's bash configuration";
    };
  };

  config = lib.mkIf config.tsrk.shell.bash.enable {
    programs.bash = {
      enable = true;
    };
  };
}
