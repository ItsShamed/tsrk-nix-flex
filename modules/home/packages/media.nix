{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.media = {
      enable = lib.options.mkEnableOption "tsrk's multimedia user package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.media.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-ndi
        waveform
        droidcam-obs
        obs-websocket
        obs-webkitgtk
        obs-vkcapture
        obs-3d-effect
        obs-multi-rtmp
        obs-move-transition
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    home.packages = with pkgs; [
      inkscape-with-extensions
      gimp-with-plugins
      kdePackages.kdenlive
      tenacity
      vlc
    ];
  };
}
