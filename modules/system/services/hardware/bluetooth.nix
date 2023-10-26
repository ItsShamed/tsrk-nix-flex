{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.bluetooth.enable = lib.options.mkEnableOption "Bluetooth";
  };

  config = lib.mkIf config.tsrk.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez-tools
      blueberry
    ];
  };
}
