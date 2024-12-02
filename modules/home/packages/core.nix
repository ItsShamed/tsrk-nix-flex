{ lib, config, pkgs, ... }:

{
  options = {
    tsrk.packages.core = {
      enable = lib.options.mkEnableOption "tsrk's core user packages bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.core.enable {
    programs = {
      btop.enable = true;
      ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
      };
      fd.enable = true;
    };
  };
}
