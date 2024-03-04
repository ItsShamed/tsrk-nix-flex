{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.compatWrapper = lib.options.mkOption {
      type = lib.types.string;
      internal = true;
      readOnly = true;
      default = if config.targets.genericLinux.enable then
        "${pkgs.nixgl.nixGLDefault}/bin/nixGL"
        else "";
    };
  };
}
