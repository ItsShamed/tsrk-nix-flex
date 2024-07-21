{ self, config, lib, pkgs, ... }:

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
    # Little silly experiment
    (self.lib.generateSystemHome "root" {
      homeDir = "/root";
      modules = [ ./root.nix ];
    })
  ];

  # TODO: override keys manually when installed
  tsrk.age.bootstrapKeys = true;

  users.users.tsrk.shell = pkgs.zsh;
  programs.zsh.enable = true;

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
