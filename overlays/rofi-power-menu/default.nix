# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  rofi-power-menu = super.rofi-power-menu.overrideAttrs
    (selfAttrs: superAttrs: {
      patches = [ ./patches/0001-refactor-allow-passing-logout-command.patch ];
    });
}
