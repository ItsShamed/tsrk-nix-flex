# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.packages.pkgs.ops;
in {
  options = {
    tsrk.packages.pkgs.ops = {
      enable = lib.options.mkEnableOption "tsrk's Ops bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ansible
      opentofu
      kubectl
      kustomize
      postgresql
      sqlfluff
      vault-bin
      kubernetes-helm
    ];

    environment.pathsToLink = [ "/share/postgresql" ];
  };
}
