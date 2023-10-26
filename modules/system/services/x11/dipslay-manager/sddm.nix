{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.sddm = {
      enable = lib.options.mkEnableOptions "sddm as a display manager";
    };
  };

  config = lib.mkIf config.tsrk.sddm.enable {
    services.xserver.displayManager.sddm = {
      enable = true;
      autoNumLock = true;
    };
  };
}
