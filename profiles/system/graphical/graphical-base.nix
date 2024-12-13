{ self, ... }:

{ lib, pkgs, ... }:

{
  key = ./.;

  imports = [
    self.nixosModules.bluetooth
    self.nixosModules.sddm
    self.nixosModules.audio
    self.nixosModules.redshift
  ];

  services.xserver.enable = lib.mkForce true;

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
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
    ];
    fontconfig = {
      enable = true;
      hinting.enable = true;
    };
  };

  tsrk.packages.pkgs.desktop.enable = true;
  tsrk.redshift.enable = lib.mkDefault true;

  hardware.opentabletdriver.enable = lib.mkDefault true;
}
