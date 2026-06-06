# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  # They are vibecoding bruuuuuuuuuuuuuh
  bitwarden = super.bitwarden.override {
    electron_39 = self.electron_39-bin;
  };
}
