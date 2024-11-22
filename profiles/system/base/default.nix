{ pkgs, lib, self, host, agenix, ... }:

{

  imports = [
    self.nixosModules.packages
    self.nixosModules.disks
    self.nixosModules.sshd
    self.nixosModules.networkmanager
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US";
    LC_TIME = "en_DK.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  console.keyMap = "us";

  nix = {
    /*
    * pkgs.nixFlakes was just an alias to pkgs.nixVersions.stable, and has
    * been removed in 24.11
    * Rather just use the pkgs.nixStable alias directly at that point.
    */
    package = pkgs.nixStable;

    settings = {
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "kvm" "big-parrallel" ];
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
  environment.pathsToLink = [ "/include" "/lib" "/share" "/share/zsh" ];
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

  environment.systemPackages = [
    agenix.agenix
  ];

  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
  };

  # Sometimes it's a little bit of a pain to run some programs so i'll just use
  # nix-ld when I'm lazy to develop a proper devshell or nix package
  programs.nix-ld.enable = lib.mkDefault true;
  programs.nix-ld.libraries = with pkgs; [
    ffmpeg
    alsa-lib
    SDL2
    lttng-ust
    numactl
    libglvnd
    xorg.libXi
    udev
  ];

  boot.loader.grub = lib.mkImageMediaOverride {
    theme = "${pkgs.hyperfluent-grub-theme}";
    splashImage = "${pkgs.hyperfluent-grub-theme}/background.png";
  };

  boot.initrd.postMountCommands = ''
    printf "\033[0;33m    /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               @@@@@@@@@@\n"
    echo '  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@'
    echo ' @@@@@@@@@                  @@@@@@@       @@@@@@@@@@@'
    echo '@@@@@@@                     @@@@@@@   @@@@@@@@@@@'
    echo '@@@@@@@                     @@@@@@@@@@@@@@@@@'
    echo '@@@@@@@@                    @@@@@@@@@@@@@%'
    echo ' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    echo '   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    echo '       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    echo '     @@@@@@@@@@             @@@@@@@   @@@@@@@@@@@'
    echo '    @@@@@@@@                @@@@@@@       @@@@@@@@@@'
    echo '   @@@@@@@/                 @@@@@@@           @@@@@@@@@@'
    echo '   @@@@@@@                  @@@@@@@               @@@@@@@@@@'
    printf "\033[0;36mYou are currently booting on the \033[1;35m${host} \033[0;36m image\033[0m\n"
  '';

  system.stateVersion = "24.05";
}
