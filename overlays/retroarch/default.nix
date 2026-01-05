# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

_self: super:

{
  retroarch = super.retroarch.override {
    cores = with super.libretro; [
      citra
      dolphin
      dosbox
      gpsp
      melonds
      mgba
      mupen64plus
      ppsspp
      sameboy
      snes9x
    ];
  };
}
