{ config, self, lib, ... }:

{
  imports = [
    self.nixosModules.profile-graphical-x11
    (self.lib.generateUser "test" { password = "quoicoubeh"; canSudo = true; })
  ];

}
