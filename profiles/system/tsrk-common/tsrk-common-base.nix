# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ pkgs, lib, ... }:

{
  key = ./tsrk-common-base.nix;

  imports = with self.nixosModules; [
    profile-graphical-x11
    hostname
    containers
    lix
    # Little silly experiment
    (self.lib.generateSystemHome "root" {
      homeDir = "/root";
      modules = [ ./root.nix ];
    })
  ];

  users.users.tsrk.shell = pkgs.zsh;
  programs.zsh.enable = true;

  age.identityPaths = lib.mkOptionDefault [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # Make /etc/hosts writable by root
  # This is so that it's easy to temporarily set hostnames
  environment.etc.hosts.mode = "0644";

  tsrk.containers.docker.enable = true;

  tsrk.packages.pkgs = {
    cDev.enable = true;
    rust.enable = true;
    python.enable = true;
    ops.enable = true;
  };

  tsrk.lix.enable = true;

  tsrk.networking = {
    networkmanager.enable = true;
  };

  tsrk.containers = {
    enable = true;
    podman.enable = true;
  };

  services.fwupd.enable = lib.mkDefault true;

  xdg.portal.enable = lib.mkDefault true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal ];
  services.flatpak.enable = lib.mkDefault true;
}
