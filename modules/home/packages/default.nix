# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, ... }:

{
  imports = [
    ./core.nix
    ./desktop.nix
    ./dev.nix
    (lib.modules.importApply ./games.nix args)
    ./media.nix
    (lib.modules.importApply ./more-games.nix args)
  ];
}
