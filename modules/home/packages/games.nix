# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  inputs,
  self,
  ...
}:

{
  pkgs,
  lib,
  config,
  ...
}:

let
  gaming = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = with self.homeManagerModules; [
    overlay-unofficial-homestuck-collection
  ];

  options = {
    tsrk.packages.games = {
      enable = lib.options.mkEnableOption "tsrk's gaming bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.games.enable {
    warnings = [
      ''
        This module (packages/games.nix) installs a package from fufexan/nix-gaming, which is
        known to cause issues with nixos-install.
      ''
    ];

    # TODO: Figure out why Ruffle is breaking on Electron 41
    tsrk.extPkgs.unofficial-homestuck-collection.install = true;

    home.packages = with pkgs; [
      gaming.osu-lazer-bin
      typespeed
      tetrio-desktop
      gaming.wine-ge
      # unofficial-homestuck-collection
    ];
  };
}
