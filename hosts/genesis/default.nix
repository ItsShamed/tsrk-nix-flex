# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    self.nixosModules.sshd
    self.nixosModules.hostname
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
    (self.lib.generateSystemHome "nixos" { modules = [ ./user.nix ]; })
    self.nixosModules.profile-iso
    self.nixosModules.packages
    self.nixosModules.yubikey
  ];

  tsrk.yubikey.enable = true;
  tsrk.sshd.enable = true;
  tsrk.packages.pkgs.base.enable = true;

  nix = {

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqKG1hRtbiN+ChXAwKqpHxlyCdFQdOSo8IfsUgi8Qh6 tsrk@tsrk-forge"
  ];

  boot.postBootCommands = ''
    echo "copying config to installer..."
    cp -r -L ${self} /home/nixos/tsrk-nix-flex
  '';

  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  boot.blacklistedKernelModules = [ "elan_i2c" ];
  boot.plymouth.enable = lib.mkForce false;
}
