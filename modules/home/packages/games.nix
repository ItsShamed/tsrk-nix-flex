{ pkgs, lib, gaming, ... }:

{
  home.packages = with pkgs; [
    # gaming.osu-lazer-bin
    typespeed
    tetrio-desktop
  ];
}
