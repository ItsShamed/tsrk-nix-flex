# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

[
  ./desktop/darkman.nix
  ./desktop/dunst.nix
  ./desktop/flameshot.nix
  { path = ./desktop/i3.nix; }
  ./desktop/kitty.nix
  ./desktop/mopidy.nix
  ./desktop/music-player.nix
  { path = ./desktop/picom.nix; }
  { path = ./desktop/polybar.nix; }
  ./desktop/premid.nix
  { path = ./desktop/rofi.nix; }
  ./desktop/screenkey.nix
  ./desktop/thunderbird.nix
  ./desktop/xdg.nix
  ./desktop/xsettingsd.nix
  ./epita
  { path = ./git; }
  { path = ./nvim; }
  { path = ./packages; }
  ./shell
  ./ssh.nix
]
