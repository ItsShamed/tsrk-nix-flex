{ self, ... }:

{
  imports = [
    self.homeManagerModules.i3
    self.homeManagerModules.polybar
    self.homeManagerModules.kitty
    self.homeManagerModules.packages
    self.homeManagerModules.dunst
    self.homeManagerModules.git
    self.homeManagerModules.zsh
    self.homeManagerModules.starship
    self.homeManagerModules.bat
    self.homeManagerModules.nvim
    self.homeManagerModules.thunderbird
    self.homeManagerModules.profile-epita-tsrk
    self.homeManagerModules.xsettingsd
    self.homeManagerModules.darkman
    self.homeManagerModules.flameshot
    self.homeManagerModules.compat
  ];

  tsrk = {
    i3 = {
      enable = true;
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
    };
    git = {
      enable = true;
      cli.enable = true;
      lazygit.enable = true;
      delta.enable = true;
    };
  };

  accounts.email.accounts =
  {
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
}
