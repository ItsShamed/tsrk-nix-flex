# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-shell
    packages
    ssh
    gpg
  ];

  tsrk.ssh.enable = true;
  tsrk.gpg.enable = true;
}
