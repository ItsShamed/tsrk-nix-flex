# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  plugins.showkeys = {
    enable = true;
    settings = {
      timeout = 1;
      maxkeys = 5;
      show_count = true;
      excluded_modes = [ "i" ];
      winopts.border = "rounded";
    };
  };
}
