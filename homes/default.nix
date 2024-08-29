{ lib, self, ... }:

let
  importModule = file: rec {
    name = lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = self.lib.generateHome name { modules = [ file ]; };
  };
in
{
  flake.homeManagerConfigurations =
    builtins.listToAttrs (builtins.map importModule (import ./imports.nix));
}
