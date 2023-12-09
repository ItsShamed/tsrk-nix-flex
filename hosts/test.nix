{ config, self, lib, ... }:

{
  imports = [
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    (self.lib.generateUser "test" { password = "quoicoubeh"; canSudo = true; })
  ];

}
