{ pkgs, lib, self, host, ... }:

{

  imports = [
    self.nixOnDroidModules.packages
  ];

  time.timeZone = "Europe/Paris";

  nix = {
    package = pkgs.nixFlakes;

    substituters = [
      "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-on-droid.cachix.org"
    ];

    trustedPublicKeys = [
      "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  tsrk.packages = {
    pkgs = {
      base.enable = true;
    };
  };

  # HACK: see https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/blob/master/profiles/core/default.nix#L108-123
  # I need this for school dev
  environment.pathsToLink = [ "/include" "/lib" "/share" "/share/zsh" ];
  environment.extraOutputsToInstall = [ "out" "lib" "bin" "dev" ];
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";

    NIX_CFLAGS_COMPILE_x86_64_unknown_linux_gnu = "-I/run/current-system/sw/include";
    NIX_CFLAGS_LINK_x86_64_unknown_linux_gnu = "-L/run/current-system/sw/lib";

    CMAKE_INCLUDE_PATH = "/run/current-system/sw/include";
    CMAKE_LIBRARY_PATH = "/run/current-system/sw/lib";

    IDEA_JDK = "/run/current-system/sw/lib/openjdk/";
    PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
  };

  environment.motd = ''
    Welcome to Nix-on-Droid!

    You are currently running on the ${host} system.
    Report issues at https://github.com/nix-community/nix-on-droid/issues.
    If shell is broken, use the rescue shell by running

      /data/data/com.termux.nix/files/usr/bin/login nix-on-droid

    .
  '';

  system.stateVersion = "24.05";
}
