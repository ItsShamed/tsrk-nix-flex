# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.no-neck-pain = {
    enable = true;
    settings = {
      width = 150;
      autocmds = {
        enableOnVimEnter = true;
        enableOnTabEnter = true;
        skipEnteringNoNeckPainBuffer = true;
      };

      buffers = {
        right.enabled = false;
      };

      mappings = {
        enabled = true;
      };
      integrations.dashboard.enabled = true;
    };
  };
}
