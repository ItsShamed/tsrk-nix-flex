# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgSet, ... }:

{ pkgs, ... }:

let
  inherit (pkgSet pkgs.stdenv.hostPlatform.system) pkgsTeleport pkgsUnstable;
in
{
  key = ./.;

  imports = with self.homeManagerModules; [
    shell
    packages
  ];

  home.packages = with pkgs; [
    slack
    pkgsTeleport.teleport_15
    pritunl-ssh
    pritunl-client
    azure-cli
    argocd
    argo-workflows
    act
    _1password-gui
    _1password-cli
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    "tag +coms, class:^(Slack)$"
  ];

  tsrk.packages.ops.k9s.externalPlugins = {
    argocd = "${pkgs.k9s.src}/plugins/argocd.yaml";
    # TODO: Re-pin this to stable when 26.05
    argo-workflows = "${pkgsUnstable.k9s.src}/plugins/argo-workflows.yaml";
    remove-finalizers = "${pkgs.k9s.src}/plugins/remove-finalizers.yaml";
    pvc-debug-container = "${pkgs.k9s.src}/plugins/pvc-debug-container.yaml";
  };
}
