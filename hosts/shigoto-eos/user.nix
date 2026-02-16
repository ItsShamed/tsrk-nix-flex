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
}
