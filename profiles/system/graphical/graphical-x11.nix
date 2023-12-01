{ lib, ... }:

{
  imports = [ ./graphical-base.nix ];

  services.xserver = {
    enable = lib.mkForce true;
  };

  tsrk = {
    i3.enable = lib.mkDefault true;
    qwerty-fr.enable = lib.mkDefault true;
  };
}
