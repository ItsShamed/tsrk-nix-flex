{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    tsrk.packages.pkgs.desktop.enable =
      lib.options.mkEnableOption "tsrk's desktop bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.desktop.enable {
    environement.systemPackages = with pkgs; [
      # communication
      thunderbird
      weechat

      # images
      feh
      imagemagick
      scrot

      # video
      mpv

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
