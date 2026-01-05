# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, pkgs, ... }:

{
  system.stateVersion = "24.05";
  user.userName = "tsrk";
  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    config = ./home.nix;
    sharedModules = [ self.homeManagerModules.profile-base ];
  };
}
