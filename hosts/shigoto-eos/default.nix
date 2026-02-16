# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  imports = [
    self.nixosModules.profile-tsrk-common
    self.nixosModules.hyprland
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      initialPassword = "changeme";
      moreGroups = [
        "adbusers"
        "libvirtd"
        "dialout"
        "uucp"
        "plugdev"
      ];
      modules = [ ./user.nix ];
    })
    ./disk.nix
  ];

  hardware.facter.reportPath = ./facter.json;
  boot.plymouth.logo = ./splash.png;
}
