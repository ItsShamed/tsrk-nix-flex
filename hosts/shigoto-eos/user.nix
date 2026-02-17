# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, ... }:

{
  imports = with self.homeManagerModules; [ profile-wayland ];

  tsrk = {
    packages = {
      media.enable = true;
    };
    nvim.wakatime.enable = true;
  };

  home.packages = with pkgs; [
    slack
    teleport
    pritunl-ssh
    pritunl-client
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1200, 0x0, 1"
    ];
    input.kb_layout = "us_qwerty-fr";
  };

  tsrk.packages.ops.k9s.externalPlugins = {
    argocd = "${pkgs.k9s.src}/plugins/argocd.yaml";
    argo-workflows = "${pkgs.k9s.src}/plugins/argo-workflows.yaml";
    remove-finalizers = "${pkgs.k9s.src}/plugins/remove-finalizers.yaml";
    pvc-debug-container = "${pkgs.k9s.src}/plugins/pvc-debug-container.yaml";
  };
}
