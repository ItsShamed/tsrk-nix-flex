# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let cfg = config.tsrk.ssh;
in {
  options = {
    tsrk.ssh.enable = lib.options.mkEnableOption "tsrk's SSH config";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      controlMaster = "yes";
      controlPersist = "10m";
    };
  };
}
