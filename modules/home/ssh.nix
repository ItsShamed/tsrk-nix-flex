# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.ssh;
in
{
  options = {
    tsrk.ssh.enable = lib.options.mkEnableOption "tsrk's SSH config";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "yes";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "10m";
      };
    };
  };
}
