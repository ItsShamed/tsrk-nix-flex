{ self, pkgs, ... }:

{
  imports = [
    self.homeManagerModules.all
    ./epita.nix
  ];

  tsrk = {
    i3 = {
      enable = true;
      epitaRestrictions = true;
    };
    xsettingsd.enable = true;
    kitty.enable = true;
    darkman = {
      enable = true;
      xsettingsd.enable = true;
      kitty.enable = true;
      nvim.enable = true;
      feh.enable = true;
      delta.enable = true;
      bat.enable = true;
    };
  };
  targets.genericLinux.enable = true;

  accounts.email.accounts.tsrk = rec {
    address = "tsrk@tsrk.me";
    userName = address;
    realName = "tsrk.";
    imap.host = "zimbra002.pulseheberg.com";
    signature = {
      text = ''
        tsrk.
        https://tsrk.me
      '';
    };
    primary = true;
    thunderbird.enable = true;
  };
}
