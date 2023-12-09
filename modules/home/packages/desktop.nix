{ config, lib, pkgs, ... }:

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
  home.packages = with pkgs; [
    # Discord replacement
    armcord

    # Fonts
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "IosevkaTerm"
        "JetBrainsMono"
        "Meslo"
        "FiraCode"
      ];
    })
    iosevka
    meslo-lgs-nf

    rofi

    # The best password manager (real)
    bitwarden
    tsrk-librewolf
    spotify
  ];
}
