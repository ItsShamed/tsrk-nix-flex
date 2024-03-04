{ lib, self, ... }:
let
  importModule = file: rec {
    name = lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = self.lib.generateHome name { modules = [ file ]; };
  };
in
builtins.listToAttrs (builtins.map importModule (import ./imports.nix))
