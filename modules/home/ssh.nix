# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
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
      enableDefaultConfig = false;
      settings."*" = {
        ForwardAgent = false;
        AddKeysToAgent = false;
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "yes";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";
      };
    };
  };
}
