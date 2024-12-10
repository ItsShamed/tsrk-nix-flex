{ lib, config, ... }:

let
  cfg = config.tsrk.shell.direnv;
in
{
  options = {
    tsrk.shell.direnv = {
      enable = lib.options.mkEnableOption "tsrk's direnv configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      nix-direnv.enable = true;
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
