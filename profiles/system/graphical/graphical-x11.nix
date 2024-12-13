{ self, ... }:

{ lib, ... }:

{
  key = ./.;

  imports = [
    self.nixosModules.i3
    self.nixosModules.qwerty-fr
  ];

  tsrk = {
    i3.enable = lib.mkDefault true;
    qwerty-fr.enable = lib.mkDefault true;
  };
}
