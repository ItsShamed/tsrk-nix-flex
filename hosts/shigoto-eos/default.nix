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

let
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    self.nixosModules.profile-tsrk-common-base
    self.nixosModules.profile-work
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

  environment.systemPackages = [
    tsrkPkgs.workspaceone-intelligent-hub
  ];

  system.services.ws1-hub = {
    imports = [ tsrkPkgs.workspaceone-intelligent-hub.services.default ];
  };

  security.pki.certificateFiles = [
    "${tsrkPkgs.workspaceone-intelligent-hub}/etc/ssl/certs/omnissa-cert.pem"
  ];

  boot.plymouth.logo = ./splash.png;
  services.tlp.enable = true;
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
  services.upower.enable = true;

  # Fingerprint
  services.fprintd = {
    enable = true;
  };
  security.pam.services.login.fprintAuth = false;

  services.displayManager.sddm.wayland.enable = true;
  services.envfs.enable = true;

  environment.etc.ws1-hub = {
    target = "ws1-hub.conf";
    source = "${tsrkPkgs.workspaceone-intelligent-hub}/etc/ws1-hub.conf";
  };

  systemd.tmpfiles.settings.ws1-hub = {
    "/var/lib/ws1-hub".v = {
      group = "root";
      user = "root";
      mode = "755";
    };
    "/var/lib/ws1-hub/agent"."L+".argument =
      "${tsrkPkgs.workspaceone-intelligent-hub}/libexec/agent";
    "/var/lib/ws1-hub/data".v = {
      group = "root";
      user = "root";
      mode = "600";
    };
    "/var/run/ws1-hub".v = {
      group = "root";
      user = "root";
      mode = "700";
    };
    "/var/log/ws1-hub".v = {
      group = "root";
      user = "root";
      mode = "755";
    };
    "/var/opt/omnissa/ws1-hub".v = {
      group = "root";
      user = "root";
      mode = "744";
    };
  };
}
