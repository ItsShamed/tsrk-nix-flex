{ self, ... }:

{ lib, ... }:

{
  key = ./graphical-x11.nix;

  imports = [
    self.nixosModules.profile-graphical-base
    self.nixosModules.i3
    self.nixosModules.qwerty-fr
  ];

  tsrk = {
    i3.enable = lib.mkDefault true;
    qwerty-fr.enable = lib.mkDefault true;
  };
}
