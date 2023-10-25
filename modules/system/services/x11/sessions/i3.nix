{ config, lib, ... }:

{
  options = {
    tsrk.i3.enable = lib.options.mkEnableOption "i3 as a window manager";
  };

  config = lib.mkIf config.tsrk.i3.enable {
    services.xserver.windowManager.i3 = {
      enable = true;
    };
  };
}
