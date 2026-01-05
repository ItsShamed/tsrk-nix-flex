# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, ... }:

{
  tsrk.packages = {
    system-base.enable = true;
    ops.enable = true;
  };
  tsrk.shell.kubeswitch.enable = true;
  programs.rbw.enable = false;

  home.packages = with pkgs; [ magic-wormhole ];

  home.stateVersion = "24.05";
}
