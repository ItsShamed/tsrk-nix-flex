# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  retroarch = super.retroarch.override {
    cores = with super.libretro; [
      gw
      beetle-gba
      bsnes
      citra
      desmume
      dolphin
      dosbox
      gpsp
      mame
      melonds
      mesen
      meteor
      mgba
      mupen64plus
      pcsx2
      ppsspp
      sameboy
      snes9x
    ];
  };
}
