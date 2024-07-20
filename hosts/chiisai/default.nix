{ self, config, lib, ... }:

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
      modules = [
        ./user.nix
      ];
    })
  ];

  # TODO: override keys manually when installed
  tsrk.age.bootstrapKeys = true;

  tsrk.nvim.wakatime.enable = true;

  age.secrets.zpasswd.file = ./secrets/passwd.age;

  age.identityPaths = lib.mkOptionDefault [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];

  tsrk.packages.pkgs = {
    cDev.enable = true;
    java.enable = true;
  };
}
