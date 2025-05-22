# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  sound-theme-freedesktop = super.sound-theme-freedesktop.overrideAttrs
    (selfAttrs: superAttrs: {
      fixupPhase = ''
        cp -f ${./bell.oga} $out/share/sounds/freedesktop/stereo/bell.oga
      '';
    });
}
