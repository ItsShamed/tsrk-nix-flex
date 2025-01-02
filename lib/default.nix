# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }@args:

rec {
  mkIfElse = predicate: positiveValue: negativeValue:
    lib.mkMerge [
      (lib.mkIf predicate positiveValue)
      (lib.mkIf (!predicate) negativeValue)
    ];

  generateUser = import ./generateUser.nix;
  generateHome = import ./generateHome.nix args;
  generateSystemHome = import ./generateSystemHome.nix args;
  generateFullUser = import ./generateFullUser.nix
    (args // { inherit generateUser generateSystemHome; });
  fromYAML = import ./fromYAML.nix args;
  mkGL = import ./mkGL.nix args;

  profileNeedsPkg = name: config: {
    assertion = config ? tsrk && config.tsrk ? packages;
    message =
      "This profile (${name}) requires the `package' module to be imported.";
  };
}
