{ self, config, lib, inputs, pkgs, ... }:

{
  imports = [
    self.nixosModules.profile-agenix
    self.nixosModules.sshd
    self.nixosModules.hostname
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix"
    (self.lib.generateSystemHome "nixos" {
      modules = [
        ./user.nix
      ];
    })
    self.nixosModules.profile-iso
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

  boot.postBootCommands = ''
    rm -f /etc/ssh/ssh_host_*
    ln -s ${../.tsrk-files/ssh_host_rsa_key} /etc/ssh/ssh_host_rsa_key
    ln -s ${../.tsrk-files/ssh_host_ed25519_key} /etc/ssh/ssh_host_ed25519_key
    chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ed25519_key
  '';

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  boot.blacklistedKernelModules = [ "elan_i2c" ];
  boot.plymouth.enable = lib.mkForce false;
}
