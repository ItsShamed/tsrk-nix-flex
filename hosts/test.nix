# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, lib, ... }:

{
  imports = [
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.hostname
    # (self.lib.generateUser "test" { password = "quoicoubeh"; canSudo = true; })
    (self.lib.generateFullUser "test" {
      password = "quoicoubeh";
      canSudo = true;
      modules = [ self.homeManagerModules.i3 { tsrk.i3.enable = true; } ];
    })
  ];

}
