# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, pkgSet, ... }:

name:

{ modules ? [ ], homeDir ? "/home/${name}" }:

let
  homeManagerBase = { ... }: {
    _file = ./generateHome.nix;
    key = ./generateHome.nix + ".${name}";
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  configuration = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = pkgSet.pkgs;

    modules = modules
      ++ [ homeManagerBase inputs.nixvim.homeManagerModules.nixvim ];

    extraSpecialArgs = {
      inherit self;
      inherit inputs;
    };
  };
in configuration
