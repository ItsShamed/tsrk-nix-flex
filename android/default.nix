# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, inputs, self, pkgSet, nix-on-droid, ... }:
let
  importModule = file: {
    name = lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = nix-on-droid.lib.nixOnDroidConfiguration {
      inherit (pkgSet) pkgs;
      modules = [ file ];
      extraSpecialArgs = {
        inherit self;
        inherit inputs;
      };
    };
  };
in builtins.listToAttrs (builtins.map importModule (import ./imports.nix))
