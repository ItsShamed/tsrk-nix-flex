# Copyright (c) 2026 tsrk <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  sshfs = super.sshfs.override {
    openssh = self.openssh_gssapi;
  };
}
