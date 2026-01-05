# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

let
  topLevelPackages = import ./all-packages.nix;

  callPackage =
    pkgDecl: self: super:
    (pkgDecl.callPackage self super) pkgDecl.path (pkgDecl.args self super);

  pkgToOverlay =
    name: pkgArgs: self: super:
    let
      defaultArgs = {
        callPackage = self: _super: self.callPackage;
        args = _self: _super: { };
      };

      pkgDecl =
        if builtins.isAttrs pkgArgs then
          (defaultArgs // pkgArgs)
        else
          defaultArgs // { path = pkgArgs; };

      overrideDecl = args: pkgDecl // { inherit args; };
    in
    {
      "${name}" = (callPackage pkgDecl self super) // {
        override = args: callPackage (overrideDecl args) self super;
      };
    };
in
builtins.mapAttrs pkgToOverlay topLevelPackages
