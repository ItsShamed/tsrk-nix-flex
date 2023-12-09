{ config, self, ... }:

{
  imports = [
    ./files.nix
  ];

  tsrk.sshd.customKeyPair = {
    enable = true;
    rsa = {
      private = config.age.secrets.ssh_host_rsa_key.path;
      public = ./files/ssh_host_rsa_key.pub;
    };
    ed25519 = {
      private = config.age.secrets.ssh_host_ed25519_key.path;
      public = ./files/ssh_host_ed25519_key.pub;
    };
  };
}
