{ self, config, lib, pkgs, ... }:

{
  imports = [
    self.nixosModules.profile-agenix
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
    self.nixosModules.containers
    self.nixosModules.libvirt
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      hashedPasswordFile = config.age.secrets.zpasswd.path;
      moreGroups = [ "libvirtd" ];
      modules = [
        ./user.nix
      ];
    })
    # Little silly experiment
    (self.lib.generateSystemHome "root" {
      homeDir = "/root";
      modules = [ ./root.nix ];
    })
    ./disk.nix
    ./hardware-config.nix
  ];

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
    csharp.enable = true;
    android.enable = true;
    python.enable = true;
    gaming.enable = true;
    qmk.enable = true;
    ops.enable = true;
    rust.enable = true;
  };

  tsrk.networking.networkmanager.enable = true;
  tsrk.containers = {
    enable = true;
    services.pihole.enable = true;
    docker.enable = true;
  };

  networking.nameservers = [
    "127.0.0.53"
    "1.1.1.1"
    "1.0.0.1"
  ];

  tsrk.libvirt.enable = true;

  services.libinput.touchpad.naturalScrolling = true;

  time.hardwareClockInLocalTime = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';
}
