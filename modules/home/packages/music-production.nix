# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgSet, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.music-production;
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (pkgSet pkgs.stdenv.hostPlatform.system) pkgsUnstable;
in
{
  options = {
    tsrk.packages = {
      music-production = {
        enable = lib.options.mkEnableOption "the music production package bundle";
        plugins.enable = lib.options.mkEnableOption "additionnal plugins";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          furnace
          pkgsUnstable.reaper # TODO: Remove when 7.55 is released
          reaper-reapack-extension
          yabridge
          yabridgectl
          (lib.hiPrio wineWowPackages.yabridge)
        ];
      }
      (lib.mkIf cfg.plugins.enable {
        home.packages = with pkgs; [
          vital
          lsp-plugins
          tsrkPkgs.apricot
          tsrkPkgs.regency
          tsrkPkgs.extrabold
          tsrkPkgs.fluctus
        ];
      })
    ]
  );
}
