# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, lib, pkgs, ... }:

{
  imports = [
    self.nixosModules.profile-base
    self.nixosModules.profile-graphical-base
    self.nixosModules.profile-graphical-x11
    self.nixosModules.profile-graphical-wayland
    self.nixosModules.hostname
    # (self.lib.generateUser "test" { password = "quoicoubeh"; canSudo = true; })
    (self.lib.generateFullUser "test" {
      password = "quoicoubeh";
      canSudo = true;
      modules = [
        self.homeManagerModules.profile-x11
        self.homeManagerModules.profile-wayland
        ./user.nix
      ];
    })
  ];

  users.users.test.shell = pkgs.zsh;
  tsrk.sddm.babysit = true;
  programs.zsh.enable = true;
}
