{ self, config, lib, pkgs, ... }:

{
  imports = [
    self.nixosModules.profile-agenix
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
    self.nixosModules.containers
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
    rust.enable = true;
    android.enable = true;
    python.enable = true;
    gaming.enable = true;
    go.enable = true;
    qmk.enable = true;
  };

  tsrk.networking.networkmanager.enable = true;
  tsrk.containers = {
    enable = true;
    podman.enable = true;
  };

  tsrk.sound = {
    bufferSize = 64;
    sampleRate = 44100;
  };

  time.hardwareClockInLocalTime = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --rate 165
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';
}
