# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  inputs,
  pkgs,
  ...
}:

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
    inputs.disko.nixosModules.default
    ./disk.nix
    ./hardware-config.nix
  ];

  tsrk.hyprland.enable = true;
  tsrk.sshd.enable = false;

  services.libinput.touchpad.naturalScrolling = true;

  boot.plymouth.logo = ./splash.png;
  services.tlp.settings = {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;

    CPU_DRIVER_OPMODE_ON_AC = "active";
    CPU_DRIVER_OPMODE_ON_BAT = "passive";

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";

    PLATFORM_MOBILE_ON_AC = "performance";
    PLATFORM_MOBILE_ON_BAT = "low-power";

    PLATFORM_PLATFORM_ON_AC = "performance";
    PLATFORM_PLATFORM_ON_BAT = "balanced";
    PLATFORM_PLATFORM_ON_SAV = "low-power";

    SOUND_POWER_SAVE_ON_AC = 0;
    SOUND_POWER_SAVE_ON_BAT = 10;

    START_CHARGE_THRESH_BAT0 = 30; # Dummy value
    STOP_CHARGE_THRESH_BAT0 = 80;
    TPSMAPI_ENABLE = 1;

    USB_AUTOSUSPEND = 0;
    USB_ALLOWLIST = "";
  };
  boot.tmp.tmpfsSize = "75%";

  systemd.services = {
    pritunl-client-service = {
      description = "Pritunl Client Daemon";
      script = "${pkgs.pritunl-client}/bin/pritunl-client-service";
      wantedBy = [ "network-online.target" ];
    };
  };
}
