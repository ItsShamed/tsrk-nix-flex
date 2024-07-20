{ config, lib, pkgs, ... }:

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
      librewolf

      # video
      mpv

      # cli
      kitty
      dialog

      # X.Org
      xclip
      xsel
      x11vnc
      lxappearance
    ];
  };
}
