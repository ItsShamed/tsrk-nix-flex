# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

[
  ./desktop/darkman.nix
  ./desktop/dunst.nix
  ./desktop/fcitx5.nix
  ./desktop/eww
  ./desktop/flameshot.nix
  ./desktop/gammastep.nix
  { path = ./desktop/hyprland.nix; }
  { path = ./desktop/i3.nix; }
  ./desktop/kitty.nix
  ./desktop/mopidy.nix
  ./desktop/music-player.nix
  { path = ./desktop/picom.nix; }
  { path = ./desktop/polybar.nix; }
  ./desktop/premid.nix
  { path = ./desktop/rofi.nix; }
  ./desktop/screenkey.nix
  ./desktop/syshud.nix
  ./desktop/thunderbird.nix
  ./desktop/xdg.nix
  ./desktop/xsettingsd.nix
  ./desktop/waybar
  ./epita
  { path = ./git; }
  { path = ./nvim; }
  { path = ./packages; }
  { path = ./shell; }
  ./ssh.nix
  ./systemd/session-targets.nix
]
