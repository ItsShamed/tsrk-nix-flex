{ inputs, ... }:

{ pkgs, lib, config, ... }:

let gaming = inputs.nix-gaming.packages.${pkgs.system};
in {
  options = {
    tsrk.packages.games = {
      enable = lib.options.mkEnableOption "tsrk's gaming bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.games.enable {
    warnings = [''
      This module (packages/games.nix) installs a package from fufexan/nix-gaming, which is
      known to cause issues with nixos-install.
    ''];

    home.packages = with pkgs; [
      # gaming.osu-lazer-bin
      typespeed
      tetrio-desktop
      retroarch-assets
      retroarch
      retroarch-joypad-autoconfig
      gaming.wine-ge
    ];
  };
}
