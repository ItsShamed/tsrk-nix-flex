{ config, lib, ... }:

{
  options = {
    tsrk.xdg = {
      enable = lib.options.mkEnableOption "tsrk's xdg config";
    };
  };

  config = lib.mkIf config.tsrk.xdg.enable {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
}
