{ config, lib, ... }:

{
  options = {
    tsrk.sddm = {
      enable = lib.options.mkEnableOption "sddm as a display manager";
    };
  };

  config = lib.mkIf config.tsrk.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };
  };
}
