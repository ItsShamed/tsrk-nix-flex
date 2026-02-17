# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.ops;

  externalK9sFiles = lib.mapAttrs' (n: v: {
    name = "k9s/plugins/${n}.yaml";
    value.source = v;
  }) cfg.k9s.externalPlugins;
in
{
  options = {
    tsrk.packages = {
      ops = {
        enable = lib.options.mkEnableOption "tsrk's ops bundle";
        k9s = {
          externalPlugins = lib.options.mkOption {
            description = "List of external plugins to add to the k9s runtime";
            type = with lib.types; attrsOf path;
            default = { };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
      ldns
      lazydocker
      openstackclient-full
      manilaclient
      kubeswitch
      ansible
      opentofu
      kubectl
      kustomize
      sqlfluff
      vault-bin
      kubernetes-helm
      kubectx
      kubectl-doctor
      kubectl-tree
      kubectl-view-secret
      pgo-client
      krew
      kubent
      kubespy
      stern
      rancher
    ];

    programs.k9s = {
      enable = true;

      aliases = {
        # Use pp as an alias for Pod
        pp = "v1/pods";
        dep = "deployments";
        sec = "v1/secrets";
        jo = "jobs";
      };
    };

    xdg.configFile = externalK9sFiles;
    home.shellAliases = {
      k = "kubectl";
      kns = "kubens";
      kctx = "kubectx";
      os = "openstack";
    };
  };
}
