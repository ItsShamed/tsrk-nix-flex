# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, ... }:

{
  imports = [
    ./android.nix
    ./base.nix
    ./cDev.nix
    ./cpp.nix
    ./csharp.nix
    ./desktop.nix
    ./fs.nix
    (lib.modules.importApply ./gaming.nix args)
    ./go.nix
    ./java.nix
    ./ops.nix
    ./python.nix
    ./qmk.nix
    ./rust.nix
    ./sql.nix
  ];
}
