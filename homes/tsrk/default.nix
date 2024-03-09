{ self, pkgs, inputs, ... }:

{
  imports = [
    self.homeManagerModules.all
    ./epita.nix
    ./extra-packages.nix
    (inputs.spotify-notifyx.homeManagerModules.default inputs.spotify-notifyx)
  ];

  tsrk = {
    i3 = {
      enable = true;
      epitaRestrictions = true;
      useLogind = true;
    };
    xsettingsd.enable = true;
    kitty.enable = true;
    darkman = {
      enable = true;
      nvim.enable = true;
      feh = {
        enable = true;
        dark = ./files/bocchi-tokyonight-storm.png;
        light = ./files/lagtrain-tokyonight-day.png;
      };
    };
    polybar = {
      enable = true;
      ethInterfaceName = "eno1";
      wlanInterfaceName = "wlan0";
    };
  };
  targets.genericLinux.enable = true;

  accounts.email.accounts.tsrk = rec {
    address = "tsrk@tsrk.me";
    userName = address;
    realName = "tsrk.";
    imap = {
      host = "zimbra002.pulseheberg.com";
      port = 993;
    };
    signature = {
      showSignature = "append";
      text = ''
        tsrk.
        https://tsrk.me
      '';
    };
    primary = true;
    thunderbird.enable = true;
  };
}
