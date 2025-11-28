# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, ... }:

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  proton-osu-bin = inputs.nix-gaming.packages.${system}.proton-osu-bin;
in
{
  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

  options = {
    tsrk.packages.pkgs = {
      gaming = {
        enable = lib.options.mkEnableOption "tsrk's gaming package bundle";
        amdSupport = lib.options.mkEnableOption "AMD support";
      };
    };
  };

  config = lib.mkIf config.tsrk.packages.pkgs.gaming.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          gamemode
          protontricks
          umu-launcher
        ];

        hardware.steam-hardware.enable = lib.mkDefault true;
        programs.steam = {
          enable = lib.mkDefault true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
            proton-osu-bin
          ];
          remotePlay.openFirewall = lib.mkDefault true;
          localNetworkGameTransfers.openFirewall = lib.mkDefault true;
          platformOptimizations.enable = lib.mkDefault true;
        };

        services.joycond.enable = lib.mkDefault true;
      }
      (lib.mkIf (config.tsrk.packages.pkgs.gaming.amdSupport) {
        hardware.opengl = {
          extraPackages = [ pkgs.amdvlk ];
          extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
        };
      })
    ]
  );
}
