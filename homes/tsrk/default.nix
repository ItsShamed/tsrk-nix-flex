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

  home.packages = with pkgs; [
    librewolf
  ];
}
