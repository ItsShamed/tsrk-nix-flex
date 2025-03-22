# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, self, inputs, ... }:

let system = "x86_64-linux";
in {
  nixos = (lib.nixosSystem {
    inherit system;
    modules = [ self.nixosModules.all ];
    specialArgs = {
      inherit inputs self;
      inherit (inputs) home-manager;
      vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" {
        inherit (inputs.nixpkgs) lib;
      };
      gaming = inputs.nix-gaming.packages.${system};
      host = "lspHints";
      agenix = inputs.agenix.packages.${system};
    };
  }).options;

  homeManager = (self.lib.generateHome "lspHints" {
    modules = [ self.homeManagerModules.all ];
  }).options;
}
