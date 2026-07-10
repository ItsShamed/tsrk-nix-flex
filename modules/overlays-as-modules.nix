# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  overlays ? { },
  homeManagerModules,
  pkgSet,
}:

let
  affectedPackagesInfo = import ../overlays/affected-packages.nix;
in
{
  nixos = lib.mapAttrs' (n: v: {
    name = "overlay-" + n;
    value = {
      _class = "nixos";
      _file = ./overlays-as-modules.nix;
      key = ./overlays-as-modules.nix + "-overlay-${n}";

      nixpkgs.overlays = [ v ];
    };
  }) overlays;
  homeManager = lib.mapAttrs' (
    n: v:
    let
      affectedPackages' = affectedPackagesInfo.${n} or [ "${n}" ];
      affectedPackages = map (
        n: if builtins.isList n then n else [ n ]
      ) affectedPackages';
    in
    {
      name = "overlay-" + n;
      value =
        {
          options,
          lib,
          pkgs,
          ...
        }:
        let
          overlaidPkgs = pkgSet.${pkgs.stdenv.hostPlatform.system}.pkgs;
          injectedPackages = map (
            pkg: lib.getAttrFromPath pkg overlaidPkgs
          ) affectedPackages;
        in
        {
          _class = "homeManager";
          _file = ./overlays-as-modules.nix;
          key = ./overlays-as-modules.nix + "-overlay-${n}";

          imports = [ homeManagerModules.external-packages ];

          config = lib.mkMerge [
            (lib.mkIf options.nixpkgs.overlays.visible {
              nixpkgs.overlays = [ v ];
              # If overlays are enabled, overlaid package is already into the
              # module's pkgs instance
              tsrk.meta.externalPackages.${n}.packages = pkgs.${n};
            })
            (lib.mkIf (!options.nixpkgs.overlays.visible) {
              tsrk.meta.externalPackages.${n}.packages = injectedPackages;
            })
          ];
        };
    }
  ) overlays;
}
