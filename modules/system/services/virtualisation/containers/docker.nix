# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  normalUsers = builtins.filter (user: config.users.users.${user}.isNormalUser)
    (builtins.attrNames config.users.users);
in {
  options = {
    tsrk.containers.docker.enable = lib.options.mkEnableOption "Docker";
  };

  config = lib.mkIf config.tsrk.containers.docker.enable {
    tsrk.containers.enable = lib.mkDefault true;

    virtualisation.docker = {
      enable = lib.mkDefault false;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    users.extraGroups.docker.members = normalUsers;

    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
