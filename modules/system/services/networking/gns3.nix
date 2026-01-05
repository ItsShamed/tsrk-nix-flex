# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.gns3;
in
{
  options = {
    tsrk.gns3 = {
      enable = lib.options.mkEnableOption "tsrk's GNS3 setup";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gns3-gui
      vpcs
    ];

    services.gns3-server = {
      enable = true;
      vpcs.enable = lib.mkDefault true;
      ubridge.enable = lib.mkDefault true;
    };
  };
}
