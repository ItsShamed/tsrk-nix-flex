{ config, pkgs, lib, ... }:

{
  i18n.defaultLocale = "en.UTF-8";
  i18.extraLocaleSettings = {
    LANGUAGE = "en:en_US:C:fr_FR";
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
        "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr" # We never know, I use their flake so we might as well reduce the network overhead
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.enableRedistributableFirmware = true;

  tsrk.disk-management.enable = lib.mkDefault true;

  system.stateVersion = "23.11";
}
