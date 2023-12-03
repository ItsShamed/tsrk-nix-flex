{ lib, self, ... }:

{
  imports = [
    ./graphical-base.nix
    self.nixosModules.i3
    self.nixosModules.qwerty-fr
  ];

  services.xserver = {
    enable = lib.mkForce true;
  };

  tsrk = {
    i3.enable = lib.mkDefault true;
    qwerty-fr.enable = lib.mkDefault true;
  };
}
