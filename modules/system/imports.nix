# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

[
  { path = ./network/hostname.nix; }
  ./network/networkmanager.nix
  ./network/upnp.nix
  { path = ./packages; }
  ./programs/gamescope.nix
  ./programs/yubikey.nix
  { path = ./services/audio.nix; }
  ./services/hardware/bluetooth.nix
  ./services/hardware/disks.nix
  ./services/networking/sshd
  ./services/networking/gns3.nix
  ./services/system/earlyoom
  ./services/virtualisation/containers
  ./services/virtualisation/libvirt.nix
  ./services/wayland/sessions/hyprland.nix
  { path = ./services/x11/dipslay-manager/sddm.nix; }
  ./services/x11/keyboard/qwerty-fr.nix
  ./services/x11/amdgpu.nix
  ./services/x11/sessions/i3.nix
  ./system/boot/plymouth
  ./system/kernel/v4l2loopback.nix
  { path = ./system/nix/lix.nix; }
]
