# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  self,
  inputs,
  pkgSet,
  ...
}:

let
  system = "x86_64-linux";
in
{
  nixos =
    (lib.nixosSystem {
      inherit system;
      modules = [ self.nixosModules.all ];
      specialArgs = {
        inherit inputs self pkgSet;
        inherit (inputs) home-manager;
        gaming = inputs.nix-gaming.packages.${system};
        host = "lspHints";
        agenix = inputs.agenix.packages.${system};
      };
    }).options;

  homeManager =
    (self.lib.generateHome "lspHints" {
      modules = [ self.homeManagerModules.all ];
    }).options;
}
