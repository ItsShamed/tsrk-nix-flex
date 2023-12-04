{ config, self, lib, ... }:

{
  imports = [
    self.nixosModules.profile-graphical-x11
    self.nixosModules.profile-agenix
    (self.lib.generateUser "test" { password = "quoicoubeh"; })
  ];

}
