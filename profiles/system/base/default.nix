{ config, pkgs, lib, self, inputs, ... }:

{

  imports = [
    self.nixosModules.packages
    self.nixosModules.disks
    self.nixosModules.sshd
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US:C:fr_FR";
    LC_TIME = "en_DK.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  console.keyMap = "us";

  nix = {
    package = pkgs.nixFlakes;

    settings = {
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "kvm" "big-parrallel" ];
      substituters = [
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.enableRedistributableFirmware = true;

  tsrk = {
    disk-management.enable = lib.mkDefault true;
    sshd.enable = lib.mkDefault true;
  };

  tsrk.packages = {
    pkgs = {
      base.enable = true;
      fs.enable = true;
    };
  };

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    nixos = {
      enable = true;
      includeAllModules = true;
    };
  };

  # HACK: see https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/blob/master/profiles/core/default.nix#L108-123
  # I need this for school dev
  environment.pathsToLink = [ "/include" "/lib" ];
  environment.extraOutputsToInstall = [ "out" "lib" "bin" "dev" ];
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";

    NIX_CFLAGS_COMPILE_x86_64_unknown_linux_gnu = "-I/run/current-system/sw/include";
    NIX_CFLAGS_LINK_x86_64_unknown_linux_gnu = "-L/run/current-system/sw/lib";

    CMAKE_INCLUDE_PATH = "/run/current-system/sw/include";
    CMAKE_LIBRARY_PATH = "/run/current-system/sw/lib";

    IDEA_JDK = "/run/current-system/sw/lib/openjdk/";
    PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
  };

  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
  };

  system.stateVersion = "23.11";
}
