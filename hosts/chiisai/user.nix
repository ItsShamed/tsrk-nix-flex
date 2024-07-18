{ self, ... }:

{
  imports = [
    self.profile-epita-tsrk
    self.profile-x11
    self.profile-git
    self.profile-shell
  ];

  tsrk = {
    darkman = {
      feh = {
        dark = ./files/bocchi-tokyonight-storm.png;
        light = ./files/lagtrain-tokyonight-day.png;
      };
    };
  };

  accounts.email.accounts = {
    tsrk = rec {
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
    a5ts = rec {
      address = "a5ts@tsrk.me";
      userName = address;
      realName = "a5ts";
      imap = {
        host = "zimbra002.pulseheberg.com";
        port = 993;
      };
      thunderbird.enable = true;
    };
  };

  programs.git = {
    signing = {
      signByDefault = true;
      key = "D1C2AD054267D54D248A4F43EBD46BB3049B56D6";
    };
    userEmail = "tsrk@tsrk.me";
  };
}
