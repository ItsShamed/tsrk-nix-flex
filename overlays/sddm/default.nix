# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

_self: super:

super.lib.genAttrs [ "libsForQt5" "kdePackages" ] (
  p:
  super.${p}.overrideScope (
    _pself: psuper: {
      sddm = psuper.sddm.override {
        unwrapped = (
          psuper.sddm.unwrapped.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              (super.fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/sddm/sddm/pull/2103.patch";
                hash = "sha256-HxsurSuGJjkGnC8fAiwipadAgcTUhs7n6fQ1SmvMMGc=";
              })
            ];

            cmakeFlags = (old.cmakeFlags or [ ]) ++ [
              (super.lib.cmakeBool "QT_FORCE_ASSERTS" true)
            ];
          })
        );
      };
    }
  )
)
