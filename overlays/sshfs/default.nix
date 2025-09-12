# Copyright (c) 2025 tsrk <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  sshfs = super.sshfs.override {
    callPackage = super.newScope { openssh = super.openssh_gssapi; };
  };
}
