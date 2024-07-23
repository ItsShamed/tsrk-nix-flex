{ self, lib, inputs, pkgs, ... }:

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
    self.nixosModules.packages
  ];

  tsrk.age.bootstrapKeys = true;
  tsrk.sshd.enable = true;
  tsrk.packages.pkgs.base.enable = true;

  nix = {

    settings = {
      substituters = [
        "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  age.identityPaths = lib.mkOptionDefault [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqKG1hRtbiN+ChXAwKqpHxlyCdFQdOSo8IfsUgi8Qh6 tsrk@tsrk-forge"
  ];

  boot.postBootCommands = ''
    echo "copying config to installer..."
    cp -r -L ${self} /home/nixos/tsrk-nix-flex
  '';

  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  boot.blacklistedKernelModules = [ "elan_i2c" ];
  boot.plymouth.enable = lib.mkForce false;
}
