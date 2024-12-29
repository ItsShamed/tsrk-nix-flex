# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ pkgs, lib, ... }:

{
  key = ./.;

  imports = with self.nixosModules; [
    profile-graphical-x11
    profile-agenix
    hostname
    containers
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

  # Make /etc/hosts writable by root
  # This is so that it's easy to temporarily set hostnames
  environment.etc.hosts.mode = "0644";

  tsrk.packages.pkgs = {
    cDev.enable = true;
    java = {
      enable = true;
      jdk.extraPackages = with pkgs; [ jdk17 jdk11 jdk8 ];
    };
    csharp.enable = true;
    rust.enable = true;
    android.enable = true;
    python.enable = true;
    gaming.enable = true;
    go.enable = true;
    qmk.enable = true;
    ops.enable = true;
  };

  tsrk.networking.networkmanager.enable = true;

  tsrk.containers = {
    enable = true;
    podman.enable = true;
  };

  environment.systemPackages = with pkgs; [ aria2 qbittorrent miru tailscale ];

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;

  # OBS WebSocket
  networking.firewall.allowedTCPPorts = [ 4455 ];
}
