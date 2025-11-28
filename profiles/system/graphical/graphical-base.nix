# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }@args:

{ lib, pkgs, ... }:

{
  key = ./graphical-base.nix;

  imports = [
    (lib.modules.importApply ../base args)
    self.nixosModules.bluetooth
    self.nixosModules.sddm
    self.nixosModules.audio
    self.nixosModules.plymouth
    self.nixosModules.qwerty-fr
  ];

  services.xserver.enable = lib.mkForce true;

  tsrk = {
    bluetooth.enable = lib.mkDefault true;
    sddm.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
    qwerty-fr.enable = lib.mkDefault true;
  };

  environment.variables = {
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  programs.dconf.enable = lib.mkDefault true; # To allow GTK customisation in home-manager

  services.gvfs.enable = lib.mkDefault true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts-cjk-sans
    ];
    fontconfig = {
      enable = true;
      hinting.enable = true;
    };
  };

  tsrk.packages.pkgs.desktop.enable = true;
  tsrk.boot.plymouth.enable = lib.mkDefault true;

  hardware.opentabletdriver.enable = lib.mkDefault true;
}
