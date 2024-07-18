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
        enable = true;
        feh = {
          enable = true;
          dark = lib.mkDefault ./files/cirnix-bg-dark.png;
          light = lib.mkDefault ./files/cirnix-bg-light.png;
        };
        nvim.enable = true;
      };
      dunst.enable = true;
      flameshot.enable = true;
      picom.enable = true;
      thunderbird.enable = true;
      xsettingsd.enable = true;
    };
  };
}
