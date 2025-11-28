# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, self, ... }:

{
  lib,
  config,
  pkgs,
  ...
}:

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  gaming = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options = {
    tsrk.packages.more-gaming = {
      enable = lib.options.mkEnableOption ''tsrk's "More Gaming" pacakge bundle'';
    };
  };

  config = lib.mkIf config.tsrk.packages.more-gaming.enable {
    warnings = [
      ''
        This module (packages/more-games.nix) installs a package from fufexan/nix-gaming, which is
        known to cause issues with nixos-install.
      ''
    ];
    home.packages = [
      gaming.osu-lazer-bin
      pkgs.prismlauncher
      tsrkPkgs.rewind
      pkgs.lunar-client
      pkgs.etterna
    ];
  };
}
