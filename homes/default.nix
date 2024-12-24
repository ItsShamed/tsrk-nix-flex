# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, self, ... }:
let
  importModule = file: rec {
    name = lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = self.lib.generateHome name { modules = [ file ]; };
  };
in builtins.listToAttrs (builtins.map importModule (import ./imports.nix))
