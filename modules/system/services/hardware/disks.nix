# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.disk-management.enable = lib.options.mkEnableOption "disk managment";
  };

  config = lib.mkIf config.tsrk.disk-management.enable {
    services.udisks2.enable = lib.mkDefault true;
    programs.gnome-disks.enable = lib.mkDefault true;
  };
}
