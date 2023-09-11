{ lib, pkgs, ... }:

let
  tsrk-librewolf = with pkgs;
      (wrapFirefox librewolf-unwrapped {
        nixExtensions = [
          (fetchFirefoxAddon {
            name = "CanvasBlocker";
            url = "https://addons.mozilla.org/firefox/downloads/file/4097901/canvasblocker-1.9.xpi";
            hash = "";
          })
          (fetchFirefoxAddon {
            name = "SponsorBlock";
            url = "https://addons.mozilla.org/firefox/downloads/file/4163966/sponsorblock-5.4.19.xpi";
            hash = "";
          })
          (fetchFirefoxAddon {
            name = "DeArrow";
            url = "https://addons.mozilla.org/firefox/downloads/file/4163352/dearrow-1.2.17.xpi";
            hash = "";
          })
          (fetchFirefoxAddon {
            name = "ToSDR";
            url = "https://addons.mozilla.org/firefox/downloads/file/3827536/terms_of_service_didnt_read-4.1.2.xpi";
            hash = "";
          })
        ];

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
    tsrk.packages.pkgs.desktop.enable = lib.mkEnableOption "tsrk's desktop bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.enable {
    environement.systemPackages = with pkgs; [
      # browser
      tsrk-librewolf

      # communication
      thunderbird
      weechat

      # images
      feh
      gimp
      imagemagick
      scrot

      # video
      vlc
      mpv
      libsForQt5.kdenlive

      # cli
      kitty
      dialog

      # X.Org
      xorg.xeyes
      xorg.xinit
      xorg.xkill
      xsel
      x11vnc
    ];
  };
}
