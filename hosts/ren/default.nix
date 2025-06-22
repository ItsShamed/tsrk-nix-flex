# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, config, lib, ... }:

{
  imports = [
    self.nixosModules.profile-tsrk-common
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      hashedPasswordFile = config.age.secrets.zpasswd.path;
      moreGroups = [ "adbusers" "libvirtd" "dialout" "uucp" "plugdev" ];
      modules = [ ./user.nix ];
    })
    self.nixosModules.gamescope
    ./disk.nix
    ./hardware-config.nix
    ./wireguard.nix
  ];

  age.secrets.zpasswd.file = ./secrets/passwd.age;
  age.secrets.wgHomePkey.file = ./secrets/wg-home-pkey.age;
  age.secrets.wgPulse1Pkey.file = ./secrets/wg-tsrk-small1-pkey.age;

  services.libinput.touchpad.naturalScrolling = true;

  time.hardwareClockInLocalTime = true;

  tsrk.packages.pkgs.cp.enable = true;
  tsrk.programs.gamescope.enable = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';

  virtualisation.docker.daemon.settings = {
    insecure-registries = [ "reg.ren.libvirt.local" ];
  };

  services.logind.lidSwitchExternalPower =
    config.services.logind.lidSwitchDocked;

  services.printing.enable = true;

  services.tlp.settings = {
    AMDGPU_ABM_LEVEL_ON_BAT = 2;

    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;

    CPU_DRIVER_OPMODE_ON_AC = "active";
    CPU_DRIVER_OPMODE_ON_BAT = "active";

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    MEM_SLEEP_ON_AC = "deep";
    MEM_SLEEP_ON_BAT = "deep";

    PLATFORM_MOBILE_ON_AC = "performance";
    PLATFORM_MOBILE_ON_BAT = "low-power";

    SOUND_POWER_SAVE_ON_AC = 0;
    SOUND_POWER_SAVE_ON_BAT = 10;

    START_CHARGE_THRESH_BAT0 = 0; # Dummy value
    STOP_CHARGE_THRESH_BAT0 = 1;

    USB_AUTOSUSPEND = 0;
    USB_ALLOWLIST = "";
  };

  services.upower.enable = true;
}
