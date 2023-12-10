{ self, config, ... }:

{
  imports = [
    self.nixosModules.profile-agenix
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      hashedPasswordFile = config.age.secrets.zpasswd.path;
    })
  ];
}
