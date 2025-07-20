# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, ... }:

self: super:

super.lib.genAttrs [ "libsForQt5" "kdePackages" ] (p:
  super.${p}.overrideScope (pself: psuper:
    let
      unwrapped = psuper.callPackage
        "${inputs.nixpkgs}/pkgs/applications/display-managers/sddm/unwrapped.nix"
        { };
    in {
      sddm = psuper.sddm.override {
        unwrapped = unwrapped.overrideAttrs (final: old: {
          patches = (old.patches or [ ]) ++ [
            ./patches/0001-fix-helper-do-not-badly-exit-on-SIGHUP.patch
            ./patches/0002-fix-helper-avoid-exiting-1-at-all-costs-when-session.patch
            ./patches/0003-feat-helper-log-session-stdout-and-stderr.patch
          ];
        });
      };
    }))
