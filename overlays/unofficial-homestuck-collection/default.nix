# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  # TODO: Remove this when https://github.com/NixOS/nixpkgs/pull/523535 is
  # merged and possibly backported
  unofficial-homestuck-collection =
    super.unofficial-homestuck-collection.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          ./0004-Upgrade-Electron-14-to-force-removal-of-remote-module.patch
        ];

        offlineCache = self.fetchYarnDeps {
          yarnLock = ./yarn.lock;
          hash = "sha256-CKWFtIZBASGx/1tBR8n7aKPqfj4P9dCAPIzee/DIOP8=";
        };
      });
}
