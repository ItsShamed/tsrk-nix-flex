# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, config, ... }:

{
  imports = [
    self.nixosModules.profile-tsrk-common
    self.nixosModules.gamescope
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      hashedPasswordFile = config.age.secrets.zpasswd.path;
      moreGroups = [ "adbusers" "libvirtd" ];
      modules = [ ./user.nix ];
    })
    ./disk.nix
    ./hardware-config.nix
  ];

  tsrk.programs.gamescope.enable = true;

  age.secrets.zpasswd.file = ./secrets/passwd.age;

  tsrk.sound = {
    bufferSize = 64;
    sampleRate = 44100;
    focusriteSupport = true;
  };

  time.hardwareClockInLocalTime = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --rate 165
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';

  # This is horrible for Minecraft PvP lmao
  services.libinput.mouse.middleEmulation = false;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}
