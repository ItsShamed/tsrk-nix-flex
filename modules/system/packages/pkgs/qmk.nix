{ config, lib, pkgs, ... }:

let cfg = config.tsrk.packages.pkgs.qmk;
in {
  options = {
    tsrk.packages.pkgs.qmk = {
      enable = lib.options.mkEnableOption "tsrk's QMK package bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ qmk qmk-udev-rules keymapviz ];

    hardware.keyboard.qmk.enable = lib.mkDefault true;
  };
}
