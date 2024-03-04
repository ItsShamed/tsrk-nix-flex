{ self, ... }:

{
  imports = [
    self.homeManagerModules.all
  ];

  tsrk = {
    i3.enable = true;
    xsettingsd.enable = true;
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
}
