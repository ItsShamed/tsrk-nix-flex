# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }:

{
  services.ssh-agent.enable = lib.mkDefault true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
