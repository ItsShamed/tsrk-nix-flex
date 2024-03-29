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

  tsrk.sshd.customKeyPair = {
    enable = true;
    rsa = {
      private = ../.tsrk-files/ssh_host_rsa_key;
      public = ../.tsrk-files/ssh_host_rsa_key.pub;
    };
    ed25519 = {
      private = ../.tsrk-files/ssh_host_ed25519_key;
      public = ../.tsrk-files/ssh_host_ed25519_key.pub;
    };
  };

  age.identityPaths = lib.mkOptionDefault [
    ../.tsrk-files/ssh_host_ed25519_key
    ../.tsrk-files/ssh_host_rsa_key
  ];

  tsrk.packages.pkgs = {
    cDev.enable = true;
    java.enable = true;
  };
}
