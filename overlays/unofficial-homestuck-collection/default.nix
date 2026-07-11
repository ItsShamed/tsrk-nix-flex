# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

self: super:

{
  unofficial-homestuck-collection =
    super.unofficial-homestuck-collection.override
      {
        electron = self.electron_40;
      };
}
