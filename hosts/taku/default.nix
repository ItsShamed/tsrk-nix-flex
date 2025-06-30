# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, config, ... }:

{
  imports = [
    self.nixosModules.profile-tsrk-common
    self.nixosModules.gamescope
    self.nixosModules.hyprland
    self.nixosModules.gns3
    self.nixosModules.amdgpu
    (self.lib.generateFullUser "tsrk" {
      canSudo = true;
      initialPassword = "changeme";
      moreGroups = [ "adbusers" "libvirtd" ];
      modules = [ ./user.nix ];
    })
    ./disk.nix
    ./hardware-config.nix
  ];

  environment.systemPackages = with pkgs; [ parsec-bin parse-cli-bin ];

  tsrk.programs.gamescope.enable = true;

  tsrk.hyprland.enable = true;

  tsrk.sound.focusriteSupport = true;

  services.pipewire.extraConfig.pipewire."10-tsrk-issues" = {
    "context.properties"."default.clock.max-quantum" = 128;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  tsrk.gns3.enable = true;

  tsrk.packages.pkgs.java.jdk.extraPackages = with pkgs; [ temurin-jre-bin-17 ];
  tsrk.packages.pkgs.cp.enable = true;

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

  tsrk.x11.amdgpu = {
    enable = true;
    freeSync = true;
    # https://wiki.archlinux.org/title/AMDGPU#Reduce_output_latency
    pageFlip = false;
    tearFree = false;
  };
}
