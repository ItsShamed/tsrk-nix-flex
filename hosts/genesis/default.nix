{ self, config, lib, ... }:

{
  imports = [
    self.nixosModules.profile-agenix
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
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

  boot.blacklistedKernelModules = [ "elan_i2c" ];
}
