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
      passwordFile = config.age.secrets.passwd.path;
    })
  ];
}
