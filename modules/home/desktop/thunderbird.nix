# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.thunderbird.enable = lib.options.mkEnableOption "Mozilla Thunderbird";
  };

  config = lib.mkIf config.tsrk.thunderbird.enable {
    programs.thunderbird = {
      enable = lib.mkDefault true;
      profiles."${config.home.username}" = { isDefault = true; };
    };
  };
}
