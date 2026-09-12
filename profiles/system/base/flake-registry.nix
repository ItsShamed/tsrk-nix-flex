# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }:

{

  nix.registry =
    let
      indirectionPair = ref: {
        name = "nixpkgs-${ref}";
        value = lib.mkDefault {
          from = {
            type = "indirect";
            id = "nixpkgs";
            inherit ref;
          };
          to = {
            type = "tarball";
            url = "https://channels.nixos.org/${ref}/nixexprs.tar.zst";
          };
        };
      };

      nixpkgsIndirections' =
        version:
        lib.genAttrs' [
          "nixos-${version}"
          "nixos-${version}-small"
          "nixpkgs-${version}-darwin"
        ] indirectionPair;

      rollingVersions =
        baseVersion:
        let
          baseMajor = lib.toInt (builtins.head (builtins.splitVersion baseVersion));
          rollingMajors = map toString [
            (baseMajor - 1)
            baseMajor
            (baseMajor + 1)
          ];
        in
        builtins.foldl' (
          prev: major:
          prev
          ++ [
            "${major}.05"
            "${major}.11"
          ]
        ) [ ] rollingMajors;

      nixpkgsIndirections =
        version:
        builtins.foldl' (prev: ver: prev // nixpkgsIndirections' ver) { } (
          rollingVersions version
        );
    in
    nixpkgsIndirections "26.05";
}
