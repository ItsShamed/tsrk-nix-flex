# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ], homeDir ? "/home/${name}"

, password ? null, hashedPasswordFile ? null, canSudo ? false, moreGroups ? [ ]
}:

{
  _file = ./generateFullUser.nix;
  key = ./generateFullUser.nix + ".${name}";

  imports = [
    (generateSystemHome name { inherit modules homeDir; })
    (generateUser name {
      inherit password hashedPasswordFile canSudo moreGroups;
    })
  ];
}
