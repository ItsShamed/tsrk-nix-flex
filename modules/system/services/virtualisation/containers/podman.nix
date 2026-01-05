# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  ...
}:

{
  options = {
    tsrk.containers.podman.enable = lib.mkEnableOption "Podman";
  };

  config = {
    tsrk.containers.enable = lib.mkDefault true;
    virtualisation.podman = {
      enable = true;

      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [ podman-compose ];
    };
  };
}
