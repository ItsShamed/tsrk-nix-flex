{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.compatWrapper = lib.options.mkOption {
      type = lib.types.string;
      default = "";
      internal = true;
      readOnly = true;
      default = if config.targets.genericLinux.enable then
        "${pkgs.nixGL.nixGLDefault}/bin/nixGL"
        else "";
    };
  };
}
