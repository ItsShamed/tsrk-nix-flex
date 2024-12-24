# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, ... }:

name:

{ modules ? [ ], homeDir ? "/home/${name}" }:

{
  _file = ./generateSystemHome.nix;
  key = ./generateSystemHome.nix + ".${name}";
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.useGlobalPkgs = true;

  home-manager.users."${name}" = {
    imports = modules ++ [ inputs.nixvim.homeManagerModules.nixvim ];
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  home-manager.extraSpecialArgs = {
    inherit self;
    inherit inputs;
  };
}
