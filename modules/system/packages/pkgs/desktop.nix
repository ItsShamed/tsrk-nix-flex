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
  options = {
    tsrk.packages.pkgs.desktop.enable =
      lib.options.mkEnableOption "tsrk's desktop bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.desktop.enable {
    environment.systemPackages = with pkgs; [
      # communication
      weechat

      # images
      feh
      imagemagick
      scrot

      # Browser
      tsrk-librewolf

      # video
      mpv

      # cli
      kitty
      dialog

      # X.Org
      xclip
      xsel
      x11vnc
    ];
  };
}
