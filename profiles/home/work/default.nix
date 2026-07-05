# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgSet, ... }:

{ pkgs, lib, ... }:

let
  inherit (pkgSet.${pkgs.stdenv.hostPlatform.system}) pkgsTeleport pkgsUnstable;
  tsrkPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
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
    tsrkPkgs.notion-app
  ];

  wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
  ];

  tsrk.hyprland.windowRules = {
    slack-to-coms = {
      match.class = "^(slack)$";
      tag = "+coms";
    };
    teams-to-coms = {
      match.class = "^(teams-for-linux)$";
      tag = "+coms";
    };
    notion = {
      match.class = "^(notion)$";
      tag = "+web";
      scrolling_width = 0.667;
    };
    notion-meeting-notification = {
      match = {
        class = "^(notion)$";
        initial_title = "^Meeting Notification \\[app:ready\\]$";
      };
      float = true;
      pin = true;
      border_size = 0;
      decorate = false;
      no_blur = true;
      no_dim = true;
    };
  };

  tsrk.packages.ops.k9s.externalPlugins = {
    argocd = "${pkgs.k9s.src}/plugins/argocd.yaml";
    # TODO: Re-pin this to stable when 26.05
    argo-workflows = "${pkgsUnstable.k9s.src}/plugins/argo-workflows.yaml";
    remove-finalizers = "${pkgs.k9s.src}/plugins/remove-finalizers.yaml";
    pvc-debug-container = "${pkgs.k9s.src}/plugins/pvc-debug-container.yaml";
  };
}
