# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let cfg = config.tsrk.networking.networkmanager;
in {
  options = {
    tsrk.networking.networkmanager = {
      enable = lib.options.mkEnableOption "NetworkManager";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = { enable = lib.mkDefault true; };

    programs.nm-applet.enable = lib.mkDefault true;
  };
}
