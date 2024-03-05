{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.compatWrapper = lib.options.mkOption {
      type = lib.types.str;
      internal = true;
      readOnly = true;
      default =
        if config.targets.genericLinux.enable then
          "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL"
        else "";
    };
  };

  config = lib.mkIf config.targets.genericLinux.enable {
    home.packages = with pkgs; [
      nixgl.auto.nixGLDefault
      glibcLocales
    ];

    home.sessionVariables.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };
}
