{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # gaming.osu-lazer-bin
    typespeed
    tetrio-desktop
    retroarch-assets
    retroarchFull
    retroarch-joypad-autoconfig
  ];
}
