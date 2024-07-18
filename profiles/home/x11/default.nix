{ self, lib, ... }:

{
  imports = with self.homeManagerModules; [
    darkman
    dunst
    flameshot
    picom
    profile-x11-base
    thunderbird
    xsettingsd
  ];

  config = {
    tsrk = {
      darkman = {
        enable = lib.mkDefault true;
        feh = {
          enable = lib.mkDefault true;
          dark = lib.mkDefault ./files/cirnix-bg-dark.png;
          light = lib.mkDefault ./files/cirnix-bg-light.png;
        };
        nvim.enable = lib.mkDefault true;
      };
      dunst.enable = lib.mkDefault true;
      flameshot.enable = lib.mkDefault true;
      picom.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
      xsettingsd.enable = lib.mkDefault true;
    };
  };
}
