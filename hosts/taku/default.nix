# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, pkgs, lib, ... }:

let winappsPkgs = inputs.winapps.packages."${pkgs.system}";
in {
  imports = [
    self.nixosModules.profile-tsrk-common
    self.nixosModules.gamescope
    self.nixosModules.hyprland
    self.nixosModules.gns3
    self.nixosModules.amdgpu
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      initialPassword = "changeme";
      moreGroups = [ "adbusers" "libvirtd" "libvirt" "kvm" ];
      modules = [ ./user.nix ];
    })
    ./disk.nix
    ./hardware-config.nix
  ];

  environment.systemPackages = with pkgs; [
    mouse_m908
    winappsPkgs.winapps
    winappsPkgs.winapps-launcher
  ];

  tsrk.programs.gamescope.enable = true;

  tsrk.hyprland.enable = true;

  tsrk.sound.focusriteSupport = true;

  services.pipewire.extraConfig.pipewire."10-tsrk-issues" = {
    "context.properties"."default.clock.max-quantum" = 128;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  tsrk.gns3.enable = true;

  tsrk.packages.pkgs.java.jdk.extraPackages = with pkgs; [ temurin-jre-bin-17 ];

  time.hardwareClockInLocalTime = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --rate 165
    ${pkgs.xorg.xset}/bin/xset r rate 230 40
  '';

  # This is horrible for Minecraft PvP lmao
  services.libinput.mouse.middleEmulation = false;

  services.openssh.settings.StreamLocalBindUnlink = true;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  tsrk.x11.amdgpu = {
    enable = true;
    freeSync = true;
    # https://wiki.archlinux.org/title/AMDGPU#Reduce_output_latency
    pageFlip = false;
    tearFree = false;
  };

  # TODO: Remove this when it will be wired (hopefully one day)
  services.udev.packages = [
    (pkgs.writeText "/etc/udev.d/rules/81-wowlan.rules" ''
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", RUN+="${
        lib.getExe pkgs.iw
      } phy0 wowlan enable magic-packet"
    '')
  ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8iPsWQkF5FLBzr6q5MlLWkUCTskIhelkSkKeTJC16 cardno:33_753_805"
      ];
      hostKeys = [
        "/etc/secrets/initrd/ssh_host_rsa_key"
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];
    };
  };
}
