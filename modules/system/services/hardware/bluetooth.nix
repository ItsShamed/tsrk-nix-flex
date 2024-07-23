{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.bluetooth.enable = lib.options.mkEnableOption "Bluetooth";
  };

  config = lib.mkIf config.tsrk.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez-tools
      blueberry
    ];

    # Taken from https://github.com/Litarvan/legion/blob/main/modules/hardware/bluetooth.nix
    services.pipewire.wireplumber.extraConfig = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
  };
}
