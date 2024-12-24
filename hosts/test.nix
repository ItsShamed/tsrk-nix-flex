{ self, lib, ... }:

{
  imports = [
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
    # (self.lib.generateUser "test" { password = "quoicoubeh"; canSudo = true; })
    (self.lib.generateFullUser "test" {
      password = "quoicoubeh";
      canSudo = true;
      modules = [ self.homeManagerModules.i3 { tsrk.i3.enable = true; } ];
    })
  ];

}
