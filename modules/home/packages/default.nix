# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, ... }:

{
  imports = [
    ./compat.nix
    ./core.nix
    (lib.modules.importApply ./desktop.nix args)
    (lib.modules.importApply ./dev.nix args)
    (lib.modules.importApply ./games.nix args)
    ./media.nix
    (lib.modules.importApply ./more-games.nix args)
    (lib.modules.importApply ./music-production.nix args)
    ./ops.nix
    ./security.nix
    ./system-base.nix
  ];
}
