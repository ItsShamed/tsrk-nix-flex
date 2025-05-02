# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, self, pkgSet, ... }:

{ lib, config, pkgs, ... }:

let
  inherit (pkgSet pkgs.system) pkgsUnstable;
  tsrkPkgs = self.packages.${pkgs.system};
  gaming = inputs.nix-gaming.packages.${pkgs.system};
in {
  options = {
    tsrk.packages.more-gaming = {
      enable =
        lib.options.mkEnableOption ''tsrk's "More Gaming" pacakge bundle'';
    };
  };

  config = lib.mkIf config.tsrk.packages.more-gaming.enable {
    warnings = [''
      This module (packages/more-games.nix) installs a package from fufexan/nix-gaming, which is
      known to cause issues with nixos-install.
    ''];
    home.packages = [
      gaming.osu-lazer-bin
      gaming.osu-stable
      pkgs.prismlauncher
      tsrkPkgs.rewind
      pkgsUnstable.lunar-client
      pkgsUnstable.etterna # TODO: at 25.05 use pkgs
    ];
  };
}
