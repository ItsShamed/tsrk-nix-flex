# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, ... }:

{
  imports =
    let
      import' =
        file:
        if builtins.isAttrs file then
          assert lib.assertMsg (
            file ? path
          ) "structrued module path does not contains `path' attribute";
          lib.modules.importApply file.path args
        else
          file;
      moduleList = import ./imports.nix;
      modules = builtins.map import' moduleList;
    in
    modules;
}
