# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  imports = [ ./docker.nix ./podman.nix ./services ];

  options = {
    tsrk.containers.enable = lib.options.mkEnableOption "containers";
  };

  config = lib.mkIf config.tsrk.containers.enable {
    virtualisation.containers.registries.search = [ "docker.io" "ghcr.io" ];
  };
}
