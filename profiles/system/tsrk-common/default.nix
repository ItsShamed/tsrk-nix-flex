# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ pkgs, ... }:

{
  key = ./.;

  imports = with self.nixosModules; [
    profile-tsrk-common-base
    libvirt
    v4l2loopback
    upnp
  ];

  tsrk.libvirt.enable = true;
  tsrk.libvirt.spice.enable = true;

  tsrk.packages.pkgs = {
    java = {
      enable = true;
      jdk.extraPackages = with pkgs; [
        jdk17
        jdk11
        jdk8
      ];
    };
    qmk.enable = true;
    web.enable = true;
  };

  tsrk.lix.enable = true;

  tsrk.networking = {
    upnp.enable = true;
  };

  tsrk.containers = {
    enable = true;
    podman.enable = true;
  };

  tsrk.kernel.v4l2loopback = {
    enable = true;
    moduleOptions = {
      devices = 1;
      video_nr = 1;
      card_label = "OBS Virtual Cam";
      exclusive_caps = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    aria2
    tailscale
  ];

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;

  networking.firewall = {
    allowedTCPPorts = [
      4455 # OBS WebSocket
      57621 # Spotify P2P
      2413 # Soulseek P2P
    ];
    allowedUDPPorts = [
      57621 # Spotify P2P
      2413 # Soulseek P2P
    ];
  };

  # EPITA Kerberos config
  security.krb5 = {
    enable = true;
    settings = {
      realms."CRI.EPITA.FR".admin_server = "kerberos.pie.cri.epita.fr";
    };
  };
}
