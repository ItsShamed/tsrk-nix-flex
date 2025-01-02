# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }@args:
let
  import' = file:
    if builtins.isAttrs file then
      assert lib.assertMsg (file ? path)
        "structrued module path does not contains `path' attribute";
      lib.modules.importApply file.path args
    else
      lib.setDefaultModuleLocation file (import file);
  getPath = file:
    if builtins.isAttrs file then
      assert lib.assertMsg (file ? path)
        "structrued module path does not contains `path' attribute";
      file.path
    else
      file;
  importModule = file: {
    name = "profile-"
      + lib.strings.removeSuffix ".nix" (builtins.baseNameOf (getPath file));
    value = import' file;
  };
in builtins.listToAttrs (builtins.map importModule (import ./imports.nix))
