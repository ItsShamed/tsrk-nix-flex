# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [ packages nvim git ssh gpg shell ];

  config = {
    tsrk.packages.core.enable = lib.mkDefault true;
    tsrk.shell = {
      bash.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      enableViKeybinds = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      lsd.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
    tsrk.git = {
      enable = lib.mkDefault true;
      cli.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
    };
    tsrk.nvim.enable = lib.mkDefault true;
    tsrk.gpg.enable = lib.mkDefault true;
    tsrk.ssh.enable = lib.mkDefault true;

    # This is very annoying with 'setup-betterlockscreen.service'
    systemd.user.startServices = false;
  };
}
