{ lib, pkgs, self, ... }:

{

  imports = [
    self.nixosModules.bluetooth
    self.nixosModules.sddm
    self.nixosModules.audio
  ];

  tsrk = {
    bluetooth.enable = lib.mkDefault true;
    sddm.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
  };

  environment.variables = {
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  programs.dconf.enable = lib.mkDefault true; # To allow GTK customisation in home-manager

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
