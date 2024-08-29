{ localModules, inputs, ... }:

{ pkgs, ... }:

{
  imports = with localModules; [
    packages
    profile-x11
    profile-git
    profile-shell
    inputs.spotify-notifyx.homeManagerModules.default
  ];

  tsrk = {
    git.delta.themes = {
      light = "TokyoNight Day";
      dark = "TokyoNight Storm";
    };
    shell.bat.themes = {
      light = "TokyoNight Day";
      dark = "TokyoNight Storm";
    };
    premid.enable = true;
    packages.dev.enable = true;
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
  };

  programs.git = {
    userName = "tsrk.";
    signing = {
      signByDefault = true;
      key = "D1C2AD054267D54D248A4F43EBD46BB3049B56D6";
    };
    userEmail = "tsrk@tsrk.me";
  };

  home.packages = with pkgs; [
    deadnix
    teams-for-linux
  ];
}
