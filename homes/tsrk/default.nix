{ self, pkgs, ... }:

let
  tsrk-librewolf = with pkgs; (wrapFirefox librewolf-unwrapped {
    extraPrefs = ''
      defaultPref("pricacy.resistFingerprinting", false);
      defaultPref("privacy.resistFingerprinting.letterboxing", true);
      defaultPref("privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts", true);
      defaultPref("identity.fxaccounts.enabled", true);
      defaultPref("extensions.update.autoUpdateDefault", true);
      defaultPref("extensions.update.enabled", true);
    '';
  });
in
{
  imports = [
    self.homeManagerModules.all
  ];

  tsrk = {
    i3.enable = true;
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
    tsrk-librewolf
  ];
}
