{ lib, pkgs, ... }:

{
  tsrk = {
    bluetooth.enable = lib.mkDefault true;
    sddm.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
  };

  environment.variables = {
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
    ];
    fontconfig = {
      enable = true;
      hinting.enable = true;
    };
  };

  tsrk.packages.pkgs.desktop.enable = true;
}
