{ pkgs, lib, config, gaming, ... }:

{
  options = {
    tsrk.packages.games = {
      enable = lib.options.mkEnableOption "tsrk's gaming bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.games.enable {
    home.packages = with pkgs; [
      # gaming.osu-lazer-bin
      typespeed
      tetrio-desktop
      retroarch-assets
      retroarch
      retroarch-joypad-autoconfig
      gaming.wine-osu
      gaming.wine-ge
    ];
  };
}
