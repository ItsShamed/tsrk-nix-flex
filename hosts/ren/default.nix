# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, config, ... }:

{
  imports = [
    self.nixosModules.profile-tsrk-common
    self.nixosModules.libvirt
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      hashedPasswordFile = config.age.secrets.zpasswd.path;
      moreGroups = [ "adbusers" "libvirtd" ];
      modules = [ ./user.nix ];
    })
    ./disk.nix
    ./hardware-config.nix
  ];

  age.secrets.zpasswd.file = ./secrets/passwd.age;

  tsrk.libvirt.enable = true;

  services.libinput.touchpad.naturalScrolling = true;

  time.hardwareClockInLocalTime = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';

  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "reg.ren.libvirt.local" ];
  };
}
