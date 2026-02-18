# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  self,
  pkgs,
  pkgSet,
  ...
}:

let
  inherit (pkgSet pkgs.stdenv.hostPlatform.system) pkgsTeleport;
in
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
    pkgsTeleport.teleport_15
    pritunl-ssh
    pritunl-client
    azure-cli
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1200, 960x1080, 1"
      "desc:Iiyama North America PL2770H 0x31303331, 1920x1080@165, 0x0, 1"
      "desc:Iiyama North America PL2770H 0x30333736, 1920x1080@144, 1920x0, 1"
    ];
    workspace = [
      "name:workdir, monitor:desc:Iiyama North America PL2770H 0x31303331, default:true"
      "name:coms, monitor:desc:Iiyama North America PL2770H 0x30333736, default:true"
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
