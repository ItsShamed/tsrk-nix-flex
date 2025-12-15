# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  nixpkgs,
  nixpkgsUnstable,
  # , nixpkgsMaster
  self,
  system,
  ...
}@inputs:

let
  generateSystem =
    module:
    let
      imageName = lib.strings.removeSuffix ".nix" (builtins.baseNameOf module);
      modules =
        let
          global = {
            _file = ./.;
            key = ./.;
            lib.tsrk.imageName = imageName;
            system.name = imageName;
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
              "nixpkgs-unstable=${nixpkgsUnstable}"
              # "nixpkgs-master=${nixpkgsMaster}"
              "nixos-config=${self}"
            ];

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgsUnstable.flake = nixpkgsUnstable;
              # nixpkgsMaster.flake = nixpkgsMaster;
            };

            # nixpkgs = { inherit (pkgSet) pkgs; };
          };
        in
        [
          global
          module
        ];
    in
    {
      name = imageName;
      value = lib.nixosSystem {
        inherit system modules;
        specialArgs = { inherit inputs self; };
      };
    };
in
builtins.listToAttrs (builtins.map generateSystem (import ./hosts.nix))
