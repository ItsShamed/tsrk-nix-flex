{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.compatWrapper = lib.options.mkOption {
      type = lib.types.string;
      internal = true;
      readOnly = true;
      default = if config.targets.genericLinux.enable then
        "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL"
        else "";
    };
  };

  config = lib.mkIf config.targets.genericLinux.enable {
    home.packages = with pkgs; [
      nixgl.auto.nixGLDefault
    ];
  };
}
