# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.packages.ops;
in {
  options = {
    tsrk.packages = {
      ops = { enable = lib.options.mkEnableOption "tsrk's ops bundle"; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
      ldns
      lazydocker
      k9s
      openstackclient-full
      kubeswitch
      ansible
      opentofu
      kubectl
      kustomize
      sqlfluff
      vault-bin
      kubernetes-helm
      kubectl-doctor
      kubectl-tree
      krew
      kubent
      kubespy
      stern
    ];
  };
}
